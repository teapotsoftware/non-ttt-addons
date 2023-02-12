AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Fat Mod Food Base"
ENT.Category = "Fat Mod"
ENT.Spawnable = false 

ENT.AddFat = 1

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
			phys:SetMass(10)
		end
	end

	function ENT:Use(ply)
		if self.IsBeverage then
			self:EmitSound("npc/barnacle/barnacle_gulp" .. math.random(2) .. ".wav")
		else
			self:EmitSound("food/munch.wav")
		end

		ply:SetNWInt("fat", math.max(0, ply:GetNWInt("fat") + self.AddFat))
		self:Remove()
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end

local fat_food = {
	["fat_donut"] = {PrintName = "Donut", Model = "models/noesis/donut.mdl", AddFat = 3},
	["fat_hotdog"] = {PrintName = "Hotdog", Model = "models/food/hotdog.mdl", AddFat = 1},
	["fat_burger"] = {PrintName = "Cheeseburger", Model = "models/food/burger.mdl", AddFat = 2},
	["fat_soda"] = {PrintName = "Soda", Model = "models/props_junk/GlassBottle01a.mdl", AddFat = 1, IsBeverage = true},
	["fat_chinese"] = {PrintName = "Takeout", Model = "models/props_junk/garbage_takeoutcarton001a.mdl", AddFat = 1},
	["fat_melon"] = {PrintName = "Watermelon", Model = "models/props_junk/watermelon01.mdl", AddFat = -1},
	["fat_orange"] = {PrintName = "Orange", Model = "models/props/cs_italy/orange.mdl", AddFat = -1},
	["fat_banana"] = {PrintName = "Banana", Model = "models/props/cs_italy/bananna.mdl", AddFat = -1},
	["fat_water"] = {PrintName = "Water", Model = "models/props/cs_office/water_bottle.mdl", AddFat = -2, IsBeverage = true},
}

for k, v in SortedPairs(fat_food) do
	v.Base = "fat_food_base"
	v.Spawnable = true
	v.Category = "Fat Mod"
	scripted_ents.Register(v, k)
end
