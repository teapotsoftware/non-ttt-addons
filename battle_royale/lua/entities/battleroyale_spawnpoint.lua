AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Spawn Point"
ENT.Category = "Battle Royale"
ENT.Spawnable = true

function ENT:Initialize()
	self:SetModel("models/Items/item_item_crate.mdl")
	self:SetMoveType(MOVETYPE_NONE) -- physgun only
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end

	self:PhysWake()
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
