AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Printer Base"
ENT.Category = "Special Printers"

ENT.Spawnable = true
ENT.Model = "models/props_c17/consolebox01a.mdl"

ENT.MaxStored = 100
ENT.PrintRate = 1

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Stored")
end

function ENT:StartSound()
	self.Noise = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	self.Noise:SetSoundLevel(50)
	self.Noise:PlayEx(1, 50)
end

function ENT:OnRemove()
	if self.Noise then
		self.Noise:Stop()
	end
end

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(CONTINUOUS_USE)
		self:PhysWake()

		self:SetStored(0)
	end

	function ENT:Think()
		self:SetStored(math.Clamp(self:GetStored() + self.PrintRate, 0, self.MaxStored))
		self:NextThink(CurTime() + 1)
		return true
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() and self:GetStored() > 0 then
			if (self:GetStoredMoney() > 0) then
				caller:addMoney(self:GetStoredMoney())
				self:SetStoredMoney(0)
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		local Ang2 = self:GetAngles()

		surface.SetFont("Trebuchet24")

		Ang:RotateAroundAxis(Ang:Up(), 90)
		Ang2:RotateAroundAxis(Ang2:Up(), 90)
		Ang2:RotateAroundAxis(Ang2:Forward(), 90)

		local PrinterWidth = 130
		local FrontHeight = 40
		local BorderWidth = 20
		local BorderColor = self.Display.Border or Color(255, 0, 0)
		local BackgroundColor = self.Display.Background or Color(255, 100, 100)
		local TextColor = self.Display.Text or Color(255, 255, 255)

		local SingleSingle = -PrinterWidth + BorderWidth
		local SingleDouble = -PrinterWidth + (BorderWidth * 2)
		local DoubleSingle = (-PrinterWidth * 2) + BorderWidth
		local DoubleDouble = (-PrinterWidth * 2) + (BorderWidth * 2)

		local prog = math.ceil(Lerp(self:GetPrintingProgress() / (math.max(self.Print.Time - (5 * self:GetBatteries()), 1)), 0, 100))
		local err = self:PrinterError()

		cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang, 0.11)
			draw.RoundedBox(2, -PrinterWidth, -PrinterWidth, PrinterWidth * 2, PrinterWidth * 2, BorderColor)
			draw.RoundedBox(2, -PrinterWidth + BorderWidth, -PrinterWidth + BorderWidth, (PrinterWidth * 2) - (BorderWidth * 2), (PrinterWidth * 2) - (BorderWidth * 2), BackgroundColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 0), "Money: $"..string.Comma(self:GetStoredMoney()), "Trebuchet24", BorderColor, TextColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 1), "Progress: "..prog.."%", "Trebuchet24", BorderColor, TextColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 2), "Ink: "..self:GetInk(), "Trebuchet24", BorderColor, TextColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 3), "Batteries: "..self:GetBatteries(), "Trebuchet24", BorderColor, TextColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 4), err, "Trebuchet24", BorderColor, TextColor)
		cam.End3D2D()
		cam.Start3D2D(Pos + (Ang2:Up() * 17) + (Ang2:Right() * 4), Ang2, 0.11)
			draw.RoundedBox(2, -PrinterWidth, -PrinterWidth, PrinterWidth * 2, FrontHeight * 2, BorderColor)
			draw.RoundedBox(2, -PrinterWidth + BorderWidth, -PrinterWidth + BorderWidth, (PrinterWidth * 2) - (BorderWidth * 2), (FrontHeight * 2) - (BorderWidth * 2), BackgroundColor)
			draw.WordBox(2, SingleDouble, SingleDouble - 13, self.PrintName, "Trebuchet24", BorderColor, TextColor)
		cam.End3D2D()
	end
end
