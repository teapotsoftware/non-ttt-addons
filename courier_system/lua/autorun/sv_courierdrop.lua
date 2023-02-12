
hook.Add("DoPlayerDeath", "CourierSystem.DoPlayerDeath", function(ply)
	if ply:HasWeapon("weapon_courierpackage") then
		local pkg = ents.Create("ent_droppedpackage")
		pkg:SetPos(ply:GetPos() + Vector(0, 0, 25))
		pkg:Spawn()
	end
end)
