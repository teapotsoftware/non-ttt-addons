AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Dropped Loot"
ENT.Category = "Basic Building"

ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.IsDroppedLoot = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "PlayerName")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/CS_militia/footlocker01_closed.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:PhysWake()
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if self.loot_resources > 0 then
				ply:AddResources(self.loot_resources)
			end

			self:Remove()
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
