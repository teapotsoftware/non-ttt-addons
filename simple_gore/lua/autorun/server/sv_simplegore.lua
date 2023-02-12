
GENDER_MALE = "male"
GENDER_FEMALE = "female"

local PlayerHurtSounds = {
	[HITGROUP_HEAD] = {
		"player/drown1.wav",
		"player/drown2.wav",
		"player/drown3.wav"
	},
	[GENDER_MALE] = {
		["generic"] = {
			"vo/npc/male01/pain01.wav",
			"vo/npc/male01/pain02.wav",
			"vo/npc/male01/pain03.wav",
			"vo/npc/male01/pain04.wav",
			"vo/npc/male01/pain05.wav",
			"vo/npc/male01/pain06.wav",
			"vo/npc/male01/pain07.wav",
			"vo/npc/male01/pain08.wav",
			"vo/npc/male01/pain09.wav",
			"vo/ravenholm/monk_pain01",
			"vo/ravenholm/monk_pain02",
			"vo/ravenholm/monk_pain03",
			"vo/ravenholm/monk_pain04",
			"vo/ravenholm/monk_pain05",
			"vo/ravenholm/monk_pain06",
			"vo/ravenholm/monk_pain07",
			"vo/ravenholm/monk_pain08",
			"vo/ravenholm/monk_pain09",
			"vo/ravenholm/monk_pain10",
			"vo/ravenholm/monk_pain12",
			"vo/npc/male01/moan01.wav",
			"vo/npc/male01/moan02.wav",
			"vo/npc/male01/moan03.wav",
			"vo/npc/male01/moan04.wav",
			"vo/npc/male01/moan05.wav"
		},
		[HITGROUP_LEFTARM] = {
			"vo/npc/male01/myarm01.wav",
			"vo/npc/male01/myarm02.wav"
		},
		[HITGROUP_LEFTLEG] = {
			"vo/npc/male01/myleg01.wav",
			"vo/npc/male01/myleg02.wav"
		},
		[HITGROUP_STOMACH] = {
			"vo/npc/male01/mygut02.wav",
			"vo/npc/male01/hitingut01.wav",
			"vo/npc/male01/hitingut02.wav"
		}
	},
	[GENDER_FEMALE] = {
		["generic"] = {
			"vo/npc/female01/pain01.wav",
			"vo/npc/female01/pain02.wav",
			"vo/npc/female01/pain03.wav",
			"vo/npc/female01/pain04.wav",
			"vo/npc/female01/pain05.wav",
			"vo/npc/female01/pain06.wav",
			"vo/npc/female01/pain07.wav",
			"vo/npc/female01/pain08.wav",
			"vo/npc/female01/pain09.wav",
			"vo/npc/female01/moan01.wav",
			"vo/npc/female01/moan02.wav",
			"vo/npc/female01/moan03.wav",
			"vo/npc/female01/moan04.wav",
			"vo/npc/female01/moan05.wav"
		},
		[HITGROUP_LEFTARM] = {
			"vo/npc/female01/myarm01.wav",
			"vo/npc/female01/myarm02.wav"
		},
		[HITGROUP_LEFTLEG] = {
			"vo/npc/female01/myleg01.wav",
			"vo/npc/female01/myleg02.wav"
		},
		[HITGROUP_STOMACH] = {
			"vo/npc/female01/mygut02.wav",
			"vo/npc/female01/hitingut01.wav",
			"vo/npc/female01/hitingut02.wav"
		}
	}
}

PlayerHurtSounds[GENDER_MALE][HITGROUP_RIGHTARM] = PlayerHurtSounds[GENDER_MALE][HITGROUP_LEFTARM]
PlayerHurtSounds[GENDER_MALE][HITGROUP_RIGHTLEG] = PlayerHurtSounds[GENDER_MALE][HITGROUP_LEFTLEG]

PlayerHurtSounds[GENDER_FEMALE][HITGROUP_RIGHTARM] = PlayerHurtSounds[GENDER_FEMALE][HITGROUP_LEFTARM]
PlayerHurtSounds[GENDER_FEMALE][HITGROUP_RIGHTLEG] = PlayerHurtSounds[GENDER_FEMALE][HITGROUP_LEFTLEG]

local IsFemaleModel = {
	["models/player/alyx.mdl"] = true,
	["models/player/p2_chell.mdl"] = true,
	["models/player/mossman.mdl"] = true,
	["models/player/mossman_arctic.mdl"] = true,
	["models/player/police_fem.mdl"] = true,
}

local function GetGender(ply)
	local mdl = ply:GetModel()
	if string.find(mdl:lower(), "female") then
		return GENDER_FEMALE
	end
	return IsFemaleModel[ply:GetModel()] and GENDER_FEMALE or GENDER_MALE
end

local always_gib = CreateConVar("gore_gib_always", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Should players always gib on death?", 0, 1)
local gib_blast = CreateConVar("gore_gib_blast", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Should players always gib when killed by explosives?", 0, 1)
local gib_crush = CreateConVar("gore_gib_crush", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Should players always gib when crushed?", 0, 1)
local headshot_sounds = CreateConVar("gore_headshot_sounds", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Should headshots make special sounds?", 0, 1)
local gore_particles = CreateConVar("gore_particles", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Should players spatter out blood when hurt?", 0, 1)
local armored_particles = CreateConVar("gore_particles_armored", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Should armored players emit blood particles?", 0, 1)
local bleed_enabled = CreateConVar("gore_bleed_enabled", 1, FCVAR_ARCHIVE, "Should players bleed when hurt?", 0, 1)
local bleed_time = CreateConVar("gore_bleed_time", 6, FCVAR_ARCHIVE, "How long someone bleeds when hurt.", 0)
local bleed_freq = CreateConVar("gore_bleed_freq", 1, FCVAR_ARCHIVE, "Seconds between each spurt of blood.", 0.1)

hook.Add("EntityTakeDamage", "SimpleGore.EntityTakeDamage", function(ent, dmg)
	if IsValid(ent) and ent:IsPlayer() then
		if bleed_enabled:GetBool() then
			ent.LastDamage = CurTime()
		end
		if gore_particles:GetBool() and dmg:IsBulletDamage() and (ent:Armor() <= 0 or armored_particles:GetBool()) then
			local spat = EffectData()
			spat:SetOrigin(dmg:GetDamagePosition())
			util.Effect("blood_spatter", spat, true)
		end
		if headshot_sounds:GetBool() and ent:LastHitGroup() == HITGROUP_HEAD then
			if ent:Armor() > 0 then
				sound.Play("player/bhit_helmet-1.wav", ent:EyePos())
			else
				sound.Play("player/headshot" .. math.random(2) .. ".wav", ent:EyePos())
			end
		end
		if ent.LastHurtSound then
			ent:StopSound(ent.LastHurtSound)
		end
		ent.hurtsound_cooldown = ent.hurtsound_cooldown or 0
		if ent.hurtsound_cooldown < CurTime() and math.random(4) == 1 then
			local hg = ent:LastHitGroup()
			local gen = GetGender(ent)

			-- this is the order of priority for where something is in the table
			local snd_table = PlayerHurtSounds[hg] or PlayerHurtSounds[gen][hg] or PlayerHurtSounds[gen]["generic"]
			local snd = snd_table[math.random(1, #snd_table)]
			ent.LastHurtSound = snd
			ent:EmitSound(snd)
			ent.hurtsound_cooldown = CurTime() + SoundDuration(snd)
		end
	end
end)

local last_bleed = 0
hook.Add("Tick", "SimpleGore.Tick", function()
	if bleed_enabled:GetBool() and CurTime() - last_bleed > bleed_freq:GetFloat() then
		last_bleed = CurTime()
		for _, ply in pairs(player.GetAll()) do
			if ply.LastDamage and CurTime() - ply.LastDamage < bleed_time:GetFloat() then
				util.Decal("Blood", ply:GetPos(), ply:GetPos() - Vector(0, 0, 30), ply)
			end
		end
	end
end)

hook.Add("DoPlayerDeath", "SimpleGore.DoPlayerDeath", function(ply, atk, dmg)
	ply.LastDamage = 0
	if always_gib:GetBool() or (gib_blast:GetBool() and dmg:IsExplosionDamage()) or (gib_crush:GetBool() and dmg:IsDamageType(DMG_CRUSH)) then
		ply.DoGibDeath = true
	end
end)

hook.Add("PostPlayerDeath", "SimpleGore.PostPlayerDeath", function(ply)
	if ply.DoGibDeath then
		ply.DoGibDeath = nil
		local radius = 12
		local rag = ply:GetRagdollEntity()
		local gibcount = math.random(9, 13)
		local pos = rag:GetPos() + Vector(0, 0, 30)
		for i = 1, gibcount do
			local x = math.cos(math.rad((i / gibcount) * 360)) * radius
			local y = math.sin(math.rad((i / gibcount) * 360)) * radius
			local gib = ents.Create("ent_goregib")
			gib:SetPos(pos + Vector(x, y))
			gib:SetAngles(AngleRand())
			gib:Spawn()
			local phys = gib:GetPhysicsObject()
			if IsValid(phys) then
				local vel = VectorRand(-300, 300)
				vel.z = math.random(30, 300)
				phys:SetVelocity(vel)
			end
			if i == 1 then
				gib:SetModel("models/Gibs/HGIBS.mdl")
			end
		end
		local spat = EffectData()
		spat:SetOrigin(rag:GetPos() + Vector(0, 0, 12))
		util.Effect("gib_explosion", spat, true)
		sound.Play("player/headshot" .. math.random(2) .. ".wav", pos)
		rag:Remove()
	end
end)
