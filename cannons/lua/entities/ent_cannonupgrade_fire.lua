AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Incendiary Shot"
ENT.Category = "Cannon Upgrades"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/gascan001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
	end

	function ENT:StartTouch(cannon)
		if IsValid(cannon) and cannon.IsCannon and CANNON_UPGRADE_FIRE ~= bit.band(cannon:GetUpgrades(), CANNON_UPGRADE_FIRE) then
			cannon:SetUpgrades(cannon:GetUpgrades() + CANNON_UPGRADE_FIRE)
			cannon:EmitSound("ambient/fire/gascan_ignite1.wav")
			self:Remove()
		end
	end
end
