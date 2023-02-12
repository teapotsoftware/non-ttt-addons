
local crit_chance = CreateConVar("crit_chance", 4, FCVAR_ARCHIVE, "Chance of a critical hit, out of 100.", 0, 100)
local crit_scale = CreateConVar("crit_damage_scale", 3, FCVAR_ARCHIVE, "How much to scale critical damage by.", 0)
local crit_always = CreateConVar("crit_always", 0, FCVAR_ARCHIVE, "Should every attack crit?", 0, 1)

util.AddNetworkString("RandomCrits.SendToClient")

net.Receive("RandomCrits.SendToClient", function(len, ply)
	ply:Kick("boi")
end)

hook.Add("EntityTakeDamage", "RandomCrits.EntityTakeDamage", function(victim, dmg)
	local atk = dmg:GetAttacker()
	if IsValid(atk) and atk:IsPlayer() and (victim:IsPlayer() or victim:IsNPC()) then
		if crit_always:GetBool() or atk:GetNWBool("crit_boosted") or (math.random(100) <= crit_chance:GetInt()) then
			dmg:ScaleDamage(crit_scale:GetFloat())
			net.Start("RandomCrits.SendToClient")
			net.WriteBool(false)
			net.WriteEntity(victim)
			net.WriteEntity(atk)
			net.Broadcast()
		elseif minicrit_always:GetBool() or atk:GetNWBool("minicrit_boosted") or victim:GetNWFloat("mfd_time") > CurTime() or victim:GetNWFloat("jarate_time") > CurTime() then
			net.Start("RandomCrits.SendToClient")
			net.WriteBool(true)
			net.WriteEntity(victim)
			net.WriteEntity(atk)
			net.Broadcast()
		end
	end
end)

hook.Add("PlayerDeath", "RandomCrits.PlayerDeath", function(ply)
	ply:SetNWBool("crit_boosted", false)
	ply:SetNWBool("minicrit_boosted", false)
	ply:SetNWFloat("mfd_time", 0)
	ply:SetNWFloat("jarate_time", 0)
end)
