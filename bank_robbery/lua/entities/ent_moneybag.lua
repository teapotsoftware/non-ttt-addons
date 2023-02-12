AddCSLuaFile()

local bundle_money = CreateConVar("bank_bundle_money", 1500, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum amount of money in a stolen bag of money.", 0)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Money Bag"
ENT.Category = "Bank Robbery"

ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "CollectTime")
	self:NetworkVar("Int", 0, "Money")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/SuitCase_Passenger_Physics.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass(60)
		end

		self:SetCollectTime(false)
	end

	function ENT:Think()
		local nope = false
		for k, v in pairs(ents.FindByClass("bank_vault")) do
			if (self:GetPos():Distance(v:GetPos()) < 4096) then
				nope = true
			end
		end
		self:SetCanCollect(nope)
		if (self:GetMoney() < 1) then
			SafeRemoveEntity(self)
		end
		self:NextThink(CurTime() + 1)
		return true
	end

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			local amount
			if (self:GetMoney() < 1000) then
				amount = self:GetMoney()
			else
				amount = 1000
			end
			self:SetMoney(self:GetMoney() - amount)
			DarkRP.createMoneyBag(self:GetPos() + Vector(0, 0, 12), amount)
			if self:GetMoney() < 1 then
				SafeRemoveEntity(self)
			end
		end
	end
end

if CLIENT then
	local color_green = Color(0, 255, 0)
	local color_gray = Color(25, 25, 25)

	function ENT:Draw()
		self:DrawModel()
		
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local top = math.max(self:OBBMins().z, self:OBBMaxs().z)

		local money = self:GetMoney()
		if DarkRP then
			money = DarkRP.formatMoney(money)
		else
			money = "$" .. string.Comma(money)
		end

		local stuff = {}

		stuff[#stuff + 1] = {content = money, color = color_green}
		stuff[#stuff + 1] = {content = self.PrintName, color = color_white}

		cam.Start3D2D(Vector(pos.x, pos.y, pos.z + top - 8), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.125)
			for k, v in ipairs(stuff) do
				draw.SimpleTextOutlined(v.content, "Trebuchet24", 0, -100 - (35 * (k - 1)), v.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_gray)
			end
		cam.End3D2D()
	end
end