AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Kevlar"
ENT.Category = "Armor"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/SuitCase_Passenger_Physics.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:Armor() >= 100 then
				ply:ChatPrint("You already have armor.")
			else
				ply:SetArmor(100)
				ply:EmitSound("items/itempickup.wav")
				self:Remove()
			end
		end
	end
end
