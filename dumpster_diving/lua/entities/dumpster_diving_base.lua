AddCSLuaFile()

local cooldown = CreateConVar("dumpster_cooldown", 120, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Dumpster diving cooldown.", 0)
local money_chance = CreateConVar("dumpster_money_chance", 0.4, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Chance of finding money instead of an item.", 0, 1)
local money_min = CreateConVar("dumpster_money_min", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum amount of money you can find.", 1)
local money_max = CreateConVar("dumpster_money_max", 300, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum amount of money you can find.", 1)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Dumpster Diving Base"
ENT.Category = "Dumpster Diving"
ENT.Spawnable = false 

ENT.Model = "models/Items/combine_rifle_ammo01.mdl"
ENT.Size = 1

DUMPSTER_DIVING_STUFF = {
	{class = "item_ammo_pistol", name = "some pistol ammo"},
	{class = "item_ammo_smg1", name = "some SMG ammo"},
	{class = "item_box_buckshot", name = "some shotgun ammo"},
	{class = "item_battery", name = "an old armor vest"},
	{class = "item_healthvial", name = "some medicine"},
	{class = "item_healthkit", name = "a first aid kit"}
}

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Cooldown")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass(self.Size * 10)
		end
	end

	function ENT:Think()
		local curCooldown = self:GetCooldown()
		self:SetCooldown(math.Clamp(curCooldown - 1, 0, curCooldown))
		self:NextThink(CurTime() + 1)
		return true
	end

	function ENT:Use(ply)
		local curCooldown = self:GetCooldown()
		if curCooldown < 1 then
			self:SetCooldown(cooldown:GetInt())

			if DarkRP and math.Rand(0, 1) <= money_chance:GetFloat() then
				local money = math.random(money_min:GetInt(), money_max:GetInt())
				ply:addMoney(money)
				ply:ChatPrint("You found a wa" .. math.random(2) == 1 and "d of" or "llet containing" .. " " .. DarkRP.formatMoney(money) .. ".")
			else
				local item = DUMPSTER_DIVING_STUFF[math.random(#DUMPSTER_DIVING_STUFF)]
				ply:Give(item.class)
				ply:ChatPrint("You found " .. item.name .. ".")
			end
		else
			ply:ChatPrint("Please wait " .. string.Comma(curCooldown) .. " seconds.")
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		
		local pos = self:GetPos()
		local maxs = self:LocalToWorld(self:OBBMaxs())
		local mins = self:LocalToWorld(self:OBBMins())
		local ang = self:GetAngles()
		local top = math.max(maxs.z, mins.z)
		local curCooldown = self:GetCooldown()

		cam.Start3D2D(Vector(pos.x, pos.y, pos.z + (top - pos.z) - 8), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.125)
			draw.SimpleTextOutlined((curCooldown > 0) and ("Please wait " .. curCooldown .. " seconds.") or ("Press " .. string.upper(input.LookupBinding("+use", true)).." to rummage."), "Trebuchet24", 8, -98, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end