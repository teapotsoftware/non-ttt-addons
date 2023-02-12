AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Stove"
ENT.Category = "Meth Equipment"
ENT.Spawnable = true

ENT.IsMethStove = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Canister")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/furnitureStove001a.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(250)
		end
	end

	function ENT:StartTouch(ent)
		if IsValid(ent) and ent.IsMethGas and self:GetCanister() == NULL and ent:GetStove() == NULL then
			if CurTime() - ent.LastStove < 2 then return end
			ent:ForcePlayerDrop()
			self:SetCanister(ent)
			ent:SetStove(self)
			local weld = constraint.Weld(self, ent, 0, 0, 0, true, false)
			self:EmitSound("physics/metal/metal_barrel_impact_soft" .. math.random(4) .. ".wav")
		end
	end
else
	local color_red = Color(255, 60, 60)
	local color_green = Color(60, 255, 60)

	function ENT:Draw()
		self:DrawModel()

		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		cam.Start3D2D(Pos + (Ang:Up() * 16), Ang, 0.3)
			draw.SimpleText("Stove", "Trebuchet24", 0, -47,  color_white, TEXT_ALIGN_CENTER)
			draw.RoundedBox(2, -50, -10, 100, 30, color_red)
			local fuel
			local can = self:GetCanister()
			if can == NULL then
				fuel = "None"
			else
				fuel = can:GetFuel()
				if fuel == 0 then
					fuel = "Empty"
				else
					draw.RoundedBox(2, -50, -10, 100 * (fuel / 200), 30, color_green)
				end
			end
			draw.SimpleText("Gas: " .. fuel, "Trebuchet24", 0, -7,  color_white, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
