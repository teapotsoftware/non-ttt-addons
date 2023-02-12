AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cluster Shot"
ENT.Category = "Cannon Upgrades"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/MetalBucket01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
	end

	function ENT:StartTouch(cannon)
		if IsValid(cannon) and cannon.IsCannon and CANNON_UPGRADE_CLUSTER ~= bit.band(cannon:GetUpgrades(), CANNON_UPGRADE_CLUSTER) then
			cannon:SetUpgrades(cannon:GetUpgrades() + CANNON_UPGRADE_CLUSTER)
			cannon:EmitSound("Metal_Box.BulletImpact")
			self:Remove()
		end
	end
end
