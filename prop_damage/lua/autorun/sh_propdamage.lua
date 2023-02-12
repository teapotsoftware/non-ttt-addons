
if SERVER then
	local propdmg_scale = CreateConVar("prop_damage_scale", 0.1, FCVAR_ARCHIVE, "Scale of damage to props.", 0)
	local propdmg_boomscale = CreateConVar("prop_damage_scale_explosive", 2, FCVAR_ARCHIVE, "Additional scale of damage to props from explosive damage.", 0)

	hook.Add("PlayerSpawnedProp", "PropDamage.PlayerSpawnedProp", function(ply, mdl, ent)
		local phys = ent:GetPhysicsObject()
		if not IsValid(phys) then
			return
		end
		local hp = phys:GetMass()
		ent:SetNWInt("propdamage_maxhealth", hp)
		ent:SetNWInt("propdamage_health", hp)
	end)

	hook.Add("EntityTakeDamage", "PropDamage.EntityTakeDamage", function(ent, dmg)
		if ent:GetClass() == "prop_physics" and dmg:GetDamage() > 0 then
			dmg:ScaleDamage(propdmg_scale:GetFloat())
			if dmg:IsDamageType(DMG_BLAST) then
				dmg:ScaleDamage(propdmg_boomscale:GetFloat())
			end
			if ent:GetNWInt("propdamage_maxhealth", 0) == 0 then
				local phys = ent:GetPhysicsObject()
				if not IsValid(phys) then
					return
				end
				local hp = phys:GetMass()
				ent:SetNWInt("propdamage_maxhealth", hp)
				ent:SetNWInt("propdamage_health", hp)
			end
			ent:SetNWInt("propdamage_health", ent:GetNWInt("propdamage_health", 0) - dmg:GetDamage())
			if ent:GetNWInt("propdamage_health", 0) <= 0 then
				ent:Remove()
			end
		end
	end)
else
	local propdmg_dist = CreateConVar("prop_damage_health_distance", 220, FCVAR_ARCHIVE, "Minimum distance to see a prop's health.", 0)

	hook.Add("HUDPaint", "PropDamage.HUDPaint", function()
		local ent = LocalPlayer():GetEyeTrace().Entity
		local dist = propdmg_dist:GetInt()
		if not IsValid(ent) or ent:GetClass() ~= "prop_physics" or ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > (dist * dist) then return end

		local w = ScrW()
		local h = ScrH()
		local hp, max = ent:GetNWInt("propdamage_health", 100), ent:GetNWInt("propdamage_maxhealth", 100)
		local x, y, width, height = w / 2 - w / 10, 2 * (h / 3), w / 5, h / 15
		local status = math.Clamp(hp / max, 0, 1)
		local BarWidth = status * (width - 16)
		local cornerRadius = math.Min(8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2)

		draw.RoundedBox(8, x, y, width, height, Color(10, 10, 10, 120))
		draw.RoundedBox(cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color(255 - (status * 255), 0 + (status * 255), 0, 255))
		draw.SimpleText("Prop Health: " .. string.Comma(math.ceil(hp)), "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
	end)
end
