
local armor_prot = CreateConVar("armor_protection", 0.2, FCVAR_ARCHIVE, "How much should armor reduce damage? (0.2 = 20% damage absorbed by armor)", 0, 1)
local armor_sounds = CreateConVar("armor_sounds", 1, FCVAR_ARCHIVE, "Should players with armor make special sounds when damaged?", 0, 1)

hook.Add("ScalePlayerDamage", "BetterArmor.ScalePlayerDamage", function(ply, hit, dmg)
	if ply:Armor() > 0 then
		dmg:ScaleDamage(1 - armor_prot:GetFloat())
	end
end)

hook.Add("EntityTakeDamage", "BetterArmor.EntityTakeDamage", function(ent, dmg)
	if armor_sounds:GetBool() and IsValid(ent) and ent:IsPlayer() and ent:Armor() > 0 then
		-- ent:EmitSound("physics/metal/metal_solid_impact_hard" .. Either(math.random(2) == 1, 1, math.random(4, 5)) .. ".wav")
		ent:EmitSound("player/kevlar" .. math.random(5) .. ".wav")
	end
end)
