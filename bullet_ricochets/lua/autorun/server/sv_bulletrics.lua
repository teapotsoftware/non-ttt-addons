
local ric_sounds_enabled = CreateConVar("bullet_ricochet_sounds", 1, FCVAR_ARCHIVE, "Should bullet impacts make ricochet sounds?", 0, 1)
local ric_dmg_scale = CreateConVar("bullet_ricochet_dmg_scale", 0.8, FCVAR_ARCHIVE, "Damage multiplier per bullet ricochet.", 0, 1)
local ric_amt = CreateConVar("bullet_ricochet_amt", 2, FCVAR_ARCHIVE, "Amount of times bullets ricochet.", 0, 100)
local ric_time = CreateConVar("bullet_ricochet_time", 0.05, FCVAR_ARCHIVE, "Time it takes for a bullet to ricochet.", 0)
local rics_enabled = CreateConVar("bullet_ricochets", 1, FCVAR_ARCHIVE, "Should bullets ricochet off surfaces?", 0, 1)
local pen_enabled = CreateConVar("bullet_penetration", 0, FCVAR_ARCHIVE, "Should bullets penetrate through surfaces?", 0, 1)
local pen_dist = CreateConVar("bullet_penetration_dist", 8, FCVAR_ARCHIVE, "How far bullets can penetrate through surfaces.", 0)

local sounds = {}
for i = 1, 5 do
	sounds[i] = "^weapons/fx/rics/ric" .. i .. ".wav"
end

sound.Add({
	name = "Bullet.Ricochet",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = {90, 130},
	sound = sounds
})

local function RicochetCallback(num, atk, tr, dmg)
	if tr.HitSky or num > ric_amt:GetInt() or IsValid(tr.Entity) and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then return end

	if ric_sounds_enabled:GetBool() then
		sound.Play("Bullet.Ricochet", tr.HitPos, 80)
	end

	local trace = {}
	trace.start = tr.HitPos
	trace.endpos = trace.start + (tr.HitNormal * 16384)

	local trace = util.TraceLine(trace)
 	local DotProduct = tr.HitNormal:Dot(tr.Normal * -1) 
	
	local ric_bullet = {}
	ric_bullet.Num = 1
	ric_bullet.Src = tr.HitPos + (tr.HitNormal)
	ric_bullet.Dir = ((2 * tr.HitNormal * DotProduct) + tr.Normal) + (VectorRand() * 0.05)
	ric_bullet.Spread = Vector(0, 0, 0)
	ric_bullet.Tracer = 1
	ric_bullet.TracerName = "Impact"
	ric_bullet.Force = dmg:GetDamageForce() * ric_dmg_scale:GetFloat()
	ric_bullet.Damage = dmg:GetDamage() * ric_dmg_scale:GetFloat()
	ric_bullet.Callback = function(a, b, c)
		return RicochetCallback(num + 1, a, b, c)
	end

	timer.Simple(ric_time:GetFloat(), function() atk:FireBullets(ric_bullet) end)
	return {damage = true, effects = true}
end

hook.Add("EntityFireBullets", "BulletRicochets.EntityFireBullets", function(ent, data)
	if not isfunction(data.Callback) then
		data.Callback = function(atk, tr, dmg)
			if tr.Hit then
				if rics_enabled:GetBool() then
					RicochetCallback(1, atk, tr, dmg)
				end
				if pen_enabled:GetBool() then
					local dist = pen_dist:GetInt()
					for i = 1, dist do
						local pos = tr.HitPos + (tr.Normal * i)
						if util.IsInWorld(pos) then
							local pen_bullet = {}
							pen_bullet.Num = 1
							pen_bullet.Src = pos
							pen_bullet.Dir = tr.Normal
							pen_bullet.Spread = Vector(0, 0, 0)
							pen_bullet.Tracer = 1
							pen_bullet.TracerName = "Impact"
							pen_bullet.Force = dmg:GetDamageForce()
							pen_bullet.Damage = dmg:GetDamage()
							pen_bullet.Callback = function(a, b, c)
								return
							end
							timer.Simple(0, function()
								if not IsValid(ent) then return end
								ent:FireBullets(pen_bullet)
							end)
							break
						end
					end
				end
			end
		end
	end
	return true
end)
