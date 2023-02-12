AddCSLuaFile()

local pay_min = CreateConVar("courier_pay_min", 600, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum payout for a courier job.", 0)
local pay_max = CreateConVar("courier_pay_max", 1000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum payout for a courier job.", 0)

ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Package Collector"
ENT.Category = "Courier System"
ENT.Spawnable = true

ENT.AutomaticFrameAdvance = true

ENT.Description = "Bring me courier packages."
ENT.TextColor = Color(80, 200, 250)
ENT.TakeWeapon = "weapon_courierpackage"

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/gman_high.mdl")
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_IDLE)
		self:SetSolid(SOLID_BBOX)
		self:SetUseType(SIMPLE_USE)
		self:SetBloodColor(BLOOD_COLOR_RED)
	end

	function ENT:Use(ply)
		if ply:HasWeapon(self.TakeWeapon) then
			ply:ConCommand("lastinv")
			ply:StripWeapon(self.TakeWeapon)
			if DarkRP then
				local pay = math.random(pay_min:GetInt(), pay_max:GetInt())
				ply:ChatPrint("Thanks, here's " .. DarkRP.formatMoney(pay) .. " for your work.")
				ply:addMoney(pay)
			else
				local vial = ents.Create("item_healthvial")
				vial:SetPos(self:GetPos() + Vector(0, 0, 20))
				vial:Spawn()
				ply:ChatPrint("Thanks, here's a reward for your work.")
			end
		else
			ply:ChatPrint("You don't have a package, get one from the courier!")
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
			draw.SimpleTextOutlined(self.Description, "DermaLarge", 0, 40, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
