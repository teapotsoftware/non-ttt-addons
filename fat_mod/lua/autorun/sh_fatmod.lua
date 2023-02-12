
local function FatModifier(ply)
	return math.max(0.4, 1 - (ply:GetNWInt("fat") * 0.01))
end

hook.Add("Move", "FatMod.Move", function(ply, mv, usrcmd)
	local speed = mv:GetMaxSpeed() * FatModifier(ply)
	mv:SetMaxSpeed(speed)
	mv:SetMaxClientSpeed(speed)
end)

if SERVER then
	resource.AddFile("sound/food/munch.wav")

	hook.Add("EntityTakeDamage", "FatMod.EntityTakeDamage", function(ply, dmg)
		if IsValid(ply) and ply:IsPlayer() and (dmg:IsBulletDamage() or dmg:IsExplosionDamage()) then
			dmg:ScaleDamage(FatModifier(ply))
		end
	end)
else
	hook.Add("Think", "FatMod.Think", function(ply)
		for _, ply in ipairs(player.GetAll()) do
			local fat = ply:GetNWInt("fat")
			local scale_main = math.max(1, 1 + (fat * 0.03))
			local scale_other = math.max(1, 0.5 + (fat * 0.02))

			local ent = ply
			if not ply:Alive() then
				ent = ply:GetRagdollEntity()
				if not IsValid(ent) then return end
			end

			for i = 1, ent:GetBoneCount() do
				ent:ManipulateBoneScale(i, Vector(scale_other, scale_other, scale_other))
			end

			local spine = ent:LookupBone("ValveBiped.Bip01_Spine")
			if spine then
				ent:ManipulateBoneScale(spine, Vector(scale_main, scale_main, scale_main))
			end

			local pelvis = ent:LookupBone("ValveBiped.Bip01_Pelvis")
			if pelvis then
				ent:ManipulateBoneScale(pelvis, Vector(scale_main, scale_main, scale_main))
			end
		end
	end)
end
