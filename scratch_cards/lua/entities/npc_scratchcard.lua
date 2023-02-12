AddCSLuaFile()

local prices = {
	CreateConVar("scratchcard_price_low", 100, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Price of Low Roller scratch cards.", 0),
	CreateConVar("scratchcard_price_mid", 1000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Price of Mid Roller scratch cards.", 0),
	CreateConVar("scratchcard_price_high", 10000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Price of High Roller scratch cards.", 0)
}

local payouts = {
	{
		CreateConVar("scratchcard_payout_low_min", 20, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum payout of Low Roller scratch cards.", 0),
		CreateConVar("scratchcard_payout_low_max", 150, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum payout of Low Roller scratch cards.", 0)
	},
	{
		CreateConVar("scratchcard_payout_mid_min", 200, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum payout of Mid Roller scratch cards.", 0),
		CreateConVar("scratchcard_payout_mid_max", 1500, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum payout of Mid Roller scratch cards.", 0)
	},
	{
		CreateConVar("scratchcard_payout_high_min", 2000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum payout of High Roller scratch cards.", 0),
		CreateConVar("scratchcard_payout_high_max", 15000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum payout of High Roller scratch cards.", 0)
	}
}

local names = {"Low", "Mid", "High"}
local dialogue = {"Hello, dear friend!", "I give you quality cards, yes?", "You can win very much money!", "Would you like to gamble, friend?"}

ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Scratch Card Dealer"
ENT.Category = "Scratch Cards"
ENT.Spawnable = true

ENT.AutomaticFrameAdvance = true

ENT.Description = "Buy scratch cards here!"
ENT.TextColor = Color(200, 80, 80)

local function FormatMoney(money)
	if DarkRP then
		return DarkRP.formatMoney(money)
	end

	return "$" .. string.Comma(money)
end

if SERVER then
	util.AddNetworkString("ScratchCard.Usage")
	util.AddNetworkString("ScratchCard.Menu")

	function ENT:Initialize()
		self:SetModel("models/breen.mdl")
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_IDLE)
		self:SetSolid(SOLID_BBOX)
		self:SetUseType(SIMPLE_USE)
		self:SetBloodColor(BLOOD_COLOR_RED)
	end

	net.Receive("ScratchCard.Usage", function(len, ply)
		local tier = math.Clamp(net.ReadInt(3), 1, 3)

		if isfunction(ply.canAfford) and not ply:canAfford(prices[tier]:GetInt()) then
			ply:ChatPrint("You can't afford that!")
			return
		end

		local payout = math.random(payouts[tier][1]:GetInt(), payouts[tier][2]:GetInt())
		if isfunction(ply.addMoney) then
			ply:addMoney(payout)
		end
		ply:ChatPrint("You won " .. FormatMoney(payout) .. "!")
	end)

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			ply:ChatPrint(dialogue[math.random(#dialogue)])
			net.Start("ScratchCard.Menu")
			net.Send(ply)
		end
	end
else
	net.Receive("ScratchCard.Menu", function(len)
		local DermaPanel = vgui.Create("DFrame")
		DermaPanel:SetSize(300, 200)
		DermaPanel:SetTitle("Scratch Cards")
		DermaPanel:SetDraggable(true)
		DermaPanel:Center()
		DermaPanel:MakePopup()

		local Buttons = {}
		for i = 1, 3 do
			Buttons[i] = vgui.Create("DButton", DermaPanel)
			Buttons[i]:SetText(names[i] .. " Roller - " .. FormatMoney(prices[i]:GetInt()))
			Buttons[i]:SetPos(25, (50 * i) - 5)
			Buttons[i]:SetSize(250, 30)
			Buttons[i].DoClick = function()
				net.Start("ScratchCard.Usage")
					net.WriteInt(i, 3)
				net.SendToServer()
				DermaPanel:Close()
			end
		end
	end)

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
