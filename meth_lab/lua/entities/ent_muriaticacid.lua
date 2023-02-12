AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Muriatic Acid"
ENT.Category = "Meth Ingredients"
ENT.Spawnable = true

ENT.MethIngredient = 2

if CLIENT then return end

function ENT:Initialize()
	self:SetModel("models/props_junk/metalgascan.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end
