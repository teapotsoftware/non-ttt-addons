AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Gas"
ENT.Category = "Meth Equipment"
ENT.Spawnable = true

ENT.IsMethGas = true

local function RemoveCanister(ent)
	if ent:GetHasStove() then
		ent:SetHasStove(false)
		ent:GetStove():SetHasCanister(false)
		constraint.RemoveAll(ent)
		ent:EmitSound("physics/metal/metal_barrel_impact_soft" .. math.random(4) .. ".wav")
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stove")
	self:NetworkVar("Int", 0, "Fuel")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/propane_tank001a.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(40)
		end

		self:SetFuel(200)
		self.LastStove = CurTime()

		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 90)
		self:SetAngles(ang)
	end

	function ENT:Think()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			if self:GetStove() == NULL then
				phys:SetMass(40)
			else
				phys:SetMass(1)
			end
		end

		self:NextThink(CurTime() + 0.5)
		return true
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			local stove = self:GetStove()

			if stove == NULL then
				if self:GetFuel() <= 0 then
					self:Remove()
				end
			else
				self:SetStove(NULL)
				stove:SetCanister(NULL)
				constraint.RemoveAll(self)
				self:EmitSound("physics/metal/metal_barrel_impact_soft" .. math.random(4) .. ".wav")
				self.LastStove = CurTime()
			end
		end
	end

	function ENT:OnRemove()
		local stove = self:GetStove()
		if stove == NULL then return end
		stove:SetCanister(NULL)
		constraint.RemoveAll(self)
		self:EmitSound("physics/metal/metal_barrel_impact_soft" .. math.random(4) .. ".wav")
	end
end

if CLIENT then
	local color_red = Color(255, 60, 60)
	local color_green = Color(60, 255, 60)

	function ENT:Draw()
		self:DrawModel()

		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Up(), 180)

		cam.Start3D2D(Pos + (Ang:Up() * 4.4) + (Ang:Right() * -6) + (Ang:Forward() * 4), Ang, 0.12)
			draw.RoundedBox(2, -50, -65, 30, 200, color_red)
			if self:GetFuel() > 0 then
				draw.RoundedBox(2, -50, -65, 30, self:GetFuel(), color_green)
			end
		cam.End3D2D()
	end
end
