AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Meth Addict"
ENT.Category = "Meth"
ENT.Spawnable = true

ENT.AutomaticFrameAdvance = true

ENT.Description = "Bring me meth!"
ENT.TextColor = Color(0, 255, 255)
ENT.MethBuyer = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/Humans/Group01/Male_04.mdl")
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_IDLE)
		self:SetSolid(SOLID_BBOX)
		self:SetUseType(SIMPLE_USE)
		self:SetBloodColor(BLOOD_COLOR_RED)
	end
else
	function ENT:Draw()
		self:DrawModel()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 100), Ang, 0.35)
			draw.SimpleTextOutlined(self.PrintName, "DermaLarge", 0, 0, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
			draw.SimpleTextOutlined(self.Description, "DermaLarge", 0, 40, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
