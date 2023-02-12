AddCSLuaFile()

local paper_price = CreateConVar("newspaper_price", 5, FCVAR_ARCHIVE + FCVAR_REPLICATED, "The price of a newspaper.", 1)
local paper_class = CreateConVar("newspaper_dispenser_weapon", "weapon_newspaper", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Which weapon the newspaper dispenser gives you.")

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Newspaper Dispenser"
ENT.Category = "Newspaper"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/CS_militia/newspaperstack01.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if caller:HasWeapon(paper_class:GetString()) then
				caller:ChatPrint("You already have a newspaper.")
			else
				if isfunction(caller.canAfford) then
					local price = paper_price:GetInt()
					if caller:canAfford(price) then
						caller:addMoney(-price)
						caller:Give(paper_class:GetString())
						caller:ChatPrint("You have bought a newspaper for " .. DarkRP.formatMoney(price) .. ".")
						self:EmitSound("ambient/office/coinslot1.wav")
					else
						caller:ChatPrint("You can't afford a newspaper! (Really???)")
					end
				else
					-- not darkrp just give it to em
					caller:Give(paper_class:GetString())
					self:EmitSound("ambient/office/coinslot1.wav")
				end
			end
		end
	end
else
	function ENT:Draw()
		self:DrawModel()

		local ang = EyeAngles()
		ang = Angle(0, ang.y, 0)

		ang:RotateAroundAxis(ang:Up(), -90)
		ang:RotateAroundAxis(ang:Forward(), 90)

		pos = self:GetPos() + Vector(0, 0, math.cos(CurTime() / 2) + 35)

		cam.Start3D2D(pos, ang, 0.2)
			local money = paper_price:GetInt()
			if istable(DarkRP) and isfunction(DarkRP.formatMoney) then
				money = DarkRP.formatMoney(money)
			else
				money = "$" .. string.Comma(money)
			end
			draw.SimpleTextOutlined("Newspaper " .. money, "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
		cam.End3D2D()
	end
end
