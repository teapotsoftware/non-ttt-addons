AddCSLuaFile()

local hack_dur = CreateConVar("bank_alarm_hack_duration", 30000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum amount of money stored in the bank vault.", 0)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Alarm Speaker"
ENT.Category = "Bank Robbery"

ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "BeingRobbed")
end

if SERVER then
	util.AddNetworkString("AnnounceBankRobbery")

	function ENT:Initialize()
		self:SetModel("models/props/cs_assault/MoneyPallet.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass(200)
		end

		self:SetMoney(max_money:GetInt() * start_pct:GetFloat())
	end

	function ENT:Think()
		local money = self:GetMoney()
		if self:GetBeingRobbed() then
			if money < 1 or CurTime() - self.LastRobberyStarted >= 30 then
				self:SetBeingRobbed(false)
				return
			end

			local max = bag_money:GetInt()
			local amount
			if (money < max) then
				amount = money
			else
				amount = max
			end

			self:SetMoney(money - amount)
			local bag = ents.Create("bank_briefcase")
			bag:SetPos(self:GetPos() + Vector(0, 0, 100))
			bag:Spawn()
			bag:SetMoney(amount)
		else
			self:SetMoney(math.Clamp(money + tax_amt:GetInt(), 0, max_money:GetInt()))
			self:SetCooldown(math.Clamp(self:GetCooldown() - 1, 0, self:GetCooldown()))
		end

		self:NextThink(CurTime() + 1)
		return true
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if ply.isCP and ply:isCP() then
				ply:ChatPrint("Cops can't rob banks!")
			else
				if self:GetBeingRobbed() then
					ply:ChatPrint("This vault is currently being robbed!")
				else
					if self:GetCooldown() <= 0 then
						self:SetCooldown(rob_cooldown:GetInt())
						self:SetBeingRobbed(true)
						self.LastRobberyStarted = CurTime()
						net.Start("AnnounceBankRobbery")
						net.Broadcast()
					else
						ply:ChatPrint("Please wait " .. string.Comma(self:GetCooldown()) .. " seconds.")
					end
				end
			end
		end
	end
else
	net.Receive("AnnounceBankRobbery", function(len)
		chat.AddText(Color(255, 0, 0), "The Bank Vault is being robbed!")
	end)

	surface.CreateFont("BankVaultFont", {
		font = "Trebuchet",
		size = 48,
	})

	function ENT:Draw()
		self:DrawModel()
		
		local pos = self:GetPos()
		local ang = self:GetAngles()

		local money = self:GetMoney()
		if DarkRP then
			money = DarkRP.formatMoney(money)
		else
			money = "$" .. string.Comma(money)
		end

		local stuff = {}
	
		stuff[#stuff + 1] = {content = money, color = Color(0, 255, 0)}
		stuff[#stuff + 1] = {content = self:GetBeingRobbed() and "Robbery in progress" or ((self:GetCooldown() <= 0) and "Ready to be robbed!" or "Cooldown: "..self:GetCooldown()), color = Color(255, 0, 0)}
		stuff[#stuff + 1] = {content = self.PrintName, color = Color(255, 255, 255)}

		cam.Start3D2D(pos + (ang:Up() * 60), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.125)
			for _, v in ipairs(stuff) do
				draw.SimpleTextOutlined(v.content, "BankVaultFont", 0, -100 - (45 * (k - 1)), v.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25))
			end
		cam.End3D2D()
	end
end
