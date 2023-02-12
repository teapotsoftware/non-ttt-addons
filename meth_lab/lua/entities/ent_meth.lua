AddCSLuaFile()

local chunk_amt = CreateConVar("meth_break_chunks", 3, FCVAR_ARCHIVE + FCVAR_REPLICATED, "How many chunks meth breaks into.", 1)
local max_hp = CreateConVar("meth_break_health", 100, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Damage required to break meth into chunks.", 1)
local price_min = CreateConVar("meth_price_min", 1800, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum price for sold meth.", 1)
local price_max = CreateConVar("meth_price_max", 2200, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum price for sold meth.", 1)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Meth"
ENT.Category = "Meth"
ENT.Spawnable = true

if CLIENT then return end

local aqua = Color(0, 255, 255)

local function FixMat(rock)
	rock:SetColor(aqua)
	rock:SetMaterial("models/debug/debugwhite")
end

function ENT:Initialize()
	self:SetModel("models/props_junk/rock001a.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	FixMat(self)
	self.BreakHealth = 0
end

function ENT:OnTakeDamage(dmg)
	self.BreakHealth = self.BreakHealth + dmg:GetDamage()

	if self.BreakHealth > max_hp:GetInt() then
		for i = 1, chunk_amt:GetInt() do
			local chunk = ents.Create("ent_methchunk")
			chunk:SetPos(self:GetPos() + VectorRand(-i, i))
			chunk:Spawn()
		end

		self:Remove()
	end
end

function ENT:Think()
	FixMat(self)
end

function ENT:Use(ply)
	if IsValid(ply) and ply:IsPlayer() then
		for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 80)) do
			if ent.MethBuyer then
				if not DarkRP then
					ply:ChatPrint("Meth can only be sold in DarkRP.")
					return
				end

				local price = math.random(price_min:GetInt(), price_max:GetInt())
				ply:addMoney(price)
				ply:ChatPrint("You have sold " .. string.lower(self.PrintName) .. " for " .. DarkRP.formatMoney(price) .. ".")
				self:Remove()
			end
		end
	end
end
