AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Meth Chunk"
ENT.Category = "Meth"
ENT.Spawnable = true

hook.Add("Move", "MethLab.Move", function(ply, mv, usrcmd)
	local highness = math.min(ply:GetNWInt("meth_high"), 8)
	if highness < 1 then return end
	local speed = mv:GetMaxSpeed() * (1 + (highness * 0.1))
	mv:SetMaxSpeed(speed)
	mv:SetMaxClientSpeed(speed)
end)

if CLIENT then
	local tab = {
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}

	hook.Add("RenderScreenspaceEffects", "MethLab.RenderScreenspaceEffects", function()
		local highness = math.min(LocalPlayer():GetNWInt("meth_high"), 8)
		if highness < 1 then return end
		tab["$pp_colour_addr"] = highness * 0.02
		tab["$pp_colour_addg"] = highness * (0.006 * math.sin(CurTime() * 3))
		tab["$pp_colour_colour"] = math.max(1, highness * 0.5)
		DrawColorModify(tab)
	end)

	return
end

local aqua = Color(0, 255, 255)
local sayings = {
	"MY ARMS ARE LIKE FUCKING CANNONS",
	"HOLY SHIT I THINK I CAN PUNCH THROUGH THIS WALL",
	"I AM GOING TO THE MOON",
	"GET THESE TERMITES OUT OF MY EYES",
	"OH GOD I'M GOING NUCLEAR",
	"ANYONE ELSE FEEL LIKE RUNNING",
	"MY BLOOD IS ON FIRE",
	"HE'S GOT A DOUBLE CHEESEBURGER RIGHT THERE",
	"ITCHY SCRATCHY"
}

hook.Add("EntityTakeDamage", "MethLab.EntityTakeDamage", function(ply, dmg)
	if IsValid(ply) and ply:IsPlayer() and ply:GetNWInt("meth_high") > 0 then
		dmg:ScaleDamage(math.Clamp(1 - (ply:GetNWInt("meth_high") * 0.15), 0.25, 1))
	end
end)

hook.Add("DoPlayerDeath", "MethLab.DoPlayerDeath", function(ply)
	if IsValid(ply) and ply:GetNWInt("meth_high") > 0 then
		ply:SetNWInt("meth_high", 0)
	end
end)

local function FixMat(rock)
	rock:SetColor(aqua)
	rock:SetMaterial("models/debug/debugwhite")
end

function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01_chunk02a.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	FixMat(self)
end

function ENT:Think()
	FixMat(self)
end

function ENT:Use(ply)
	if IsValid(ply) and ply:IsPlayer() then
		local hurt = math.random(3, 7) * math.max(1, ply:GetNWInt("meth_high") * 0.5)
		if ply:Health() - hurt > 0 then
			ply:Say(sayings[math.random(#sayings)])
			ply:SetNWInt("meth_high", ply:GetNWInt("meth_high") + 1)
			ply:SetHealth(ply:Health() - hurt)
		else
			if DarkRP then
				ply:Say("/me overdoses on meth")
			else
				ply:Say("*overdoses on meth*")
			end
			ply:Kill()
			return
		end
		self:Remove()
	end
end
