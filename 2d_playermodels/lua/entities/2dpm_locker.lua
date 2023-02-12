AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Locker"
ENT.Category = "2D Playermodels"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/FurnitureDresser001a.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()
		self:SetPos(self:GetPos() + Vector(0, 0, 60))
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			net.Start("2dplayermodel_menu")
			net.Send(ply)
		end
	end
else
	surface.CreateFont("2DPM.LockerLarge", {
		font = "Arial",
		size = 150,
		weight = 500,
	})

	surface.CreateFont("2DPM.LockerSmall", {
		font = "Arial",
		size = 35,
		weight = 500,
	})

	local color_red = Color(255, 60, 60)
	local color_green = Color(60, 255, 60)

	function ENT:Draw()
		self:DrawModel()

		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		cam.Start3D2D(Pos + (Ang:Up() * 14.8) + (Ang:Right() * -30), Ang, 0.1)
			draw.SimpleText("Locker", "2DPM.LockerLarge", 0, 0,  color_white, TEXT_ALIGN_CENTER)
			draw.SimpleText("Change your playermodel!", "2DPM.LockerSmall", 0, 140,  color_white, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
