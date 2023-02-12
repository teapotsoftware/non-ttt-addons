AddCSLuaFile()

local print_money = CreateConVar("money_printer_amount", 5, FCVAR_ARCHIVE + FCVAR_REPLICATED, "How much the money printer prints.", 1)
local print_max = CreateConVar("money_printer_max", 1000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum money a printer can hold.", 1)
local print_time = CreateConVar("money_printer_time", 3, FCVAR_ARCHIVE + FCVAR_REPLICATED, "How long it takes to print money.", 0)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Money Printer"
ENT.Category = "Sandbox Money"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "StoredMoney")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/consolebox01a.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(CONTINUOUS_USE)
		self:PhysWake()

		self:SetStoredMoney(0)

		self.Noise = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
		self.Noise:SetSoundLevel(50)
		self.Noise:PlayEx(1, 50)
	end

	function ENT:Think()
		local stored = self:GetStoredMoney()
		local amt = print_money:GetInt()
		self:SetStoredMoney(stored + math.Clamp(print_max:GetInt() - stored, 0, amt))

		self:NextThink(CurTime() + print_time:GetFloat())
		return true
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() and self:GetStoredMoney() > 0 then
			ply:addMoney(self:GetStoredMoney())
			self:SetStoredMoney(0)
		end
	end

	function ENT:OnRemove()
		if self.Noise then
			self.Noise:Stop()
		end
	end
end

if CLIENT then
	local color_red = Color(255, 60, 60)
	local color_green = Color(60, 255, 60)

	local w = 120
	local h = 40

	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()
		local ang = self:GetAngles()
		local money = self:GetStoredMoney()

		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)

		cam.Start3D2D(pos + (ang:Up() * 16.9) + (ang:Right() * -5.4) + (ang:Forward() * 0.15), ang, 0.25)
			draw.RoundedBox(2, -w / 2, -h / 2, w, h, color_red)
			draw.RoundedBox(2, -w / 2, -h / 2, w * (money / print_max:GetInt()), h, color_green)
			draw.SimpleTextOutlined(DarkRP.formatMoney(money), "ChatFont", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
		cam.End3D2D()
	end
end
