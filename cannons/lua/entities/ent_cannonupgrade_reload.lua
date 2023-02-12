AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Speed Loader"
ENT.Category = "Cannon Upgrades"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_vehicles/carparts_muffler01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
	end

	function ENT:StartTouch(cannon)
		if IsValid(cannon) and cannon.IsCannon and CANNON_UPGRADE_RELOAD ~= bit.band(cannon:GetUpgrades(), CANNON_UPGRADE_RELOAD) then
			cannon:SetUpgrades(cannon:GetUpgrades() + CANNON_UPGRADE_RELOAD)
			cannon:EmitSound("Weapon_357.spin")
			self:Remove()
		end
	end
end
