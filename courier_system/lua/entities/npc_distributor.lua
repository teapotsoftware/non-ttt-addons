AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Package Courier"
ENT.Category = "Courier System"
ENT.Spawnable = true

ENT.AutomaticFrameAdvance = true

ENT.TextColor = Color(80, 200, 250)
ENT.GiveWeapon = "weapon_courierpackage"

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/odessa.mdl")
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_IDLE)
		self:SetSolid(SOLID_BBOX)
		self:SetUseType(SIMPLE_USE)
		self:SetBloodColor(BLOOD_COLOR_RED)
	end

	function ENT:Use(ply)
		if ply:HasWeapon(self.GiveWeapon) then
			ply:ChatPrint("You already have a package, take it to the collector!")
		else
			ply:Give(self.GiveWeapon)
			ply:SelectWeapon(self.GiveWeapon)
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 100), Ang, 0.35)
			draw.SimpleTextOutlined(self.PrintName, "DermaLarge", 0, 0, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
			draw.SimpleTextOutlined(Either(LocalPlayer():HasWeapon(self.GiveWeapon), "Take the package to the collector.", "Come take a package."), "DermaLarge", 0, 40, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
