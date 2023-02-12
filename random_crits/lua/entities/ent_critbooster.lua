AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crit Booster"
ENT.Category = "Random Crits"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_lab/jar01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:GetNWBool("crit_boosted") then
				ply:ChatPrint("You're already crit boosted.")
			else
				ply:SetNWBool("crit_boosted", true)
				ply:EmitSound("npc/barnacle/barnacle_gulp" .. math.random(2) .. ".wav")
				self:Remove()
			end
		end
	end
end
