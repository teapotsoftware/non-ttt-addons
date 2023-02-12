
hook.Add("EntityTakeDamage", "BasicBuilding.EntityTakeDamage", function(ent, dmg)
	if IsValid(ent) and ent.IsHarvestableNode then
		local atk = dmg:GetAttacker()
		if IsValid(atk) and atk:IsPlayer() and atk:Alive() then
			local res = dmg:GetDamage()
			if res > 0 then
				atk:AddResources(res)
			end
		end
	end
end)
