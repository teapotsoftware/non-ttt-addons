AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Range Booster"
ENT.Category = "Cannon Upgrades"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/PropaneCanister001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
	end

	function ENT:StartTouch(cannon)
		if IsValid(cannon) and cannon.IsCannon and CANNON_UPGRADE_RANGE ~= bit.band(cannon:GetUpgrades(), CANNON_UPGRADE_RANGE) then
			cannon:SetUpgrades(cannon:GetUpgrades() + CANNON_UPGRADE_RANGE)
			cannon:EmitSound("weapons/zoom.wav")
			self:Remove()
		end
	end
end
