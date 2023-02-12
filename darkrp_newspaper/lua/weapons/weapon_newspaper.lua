AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false

SWEP.PrintName = "Newspaper"
SWEP.Purpose = "What's going on in the world today?"
SWEP.Category = "Newspaper"

SWEP.DrawCrosshair = false

SWEP.Primary.Ammo = "None"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "None"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = ""

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["Detonator"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)},
	["Slam_panel"] = {scale = Vector(0.996, 0.996, 0.996), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_L_Clavicle"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 1.493, -30), angle = Angle(0, 0, 0)},
	["Slam_base"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = {scale = Vector(0.009, 0.009, 3), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

SWEP.VElements = {
	["paper"] = {type = "Model", model = "models/props_junk/garbage_newspaper001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.37, 3.904, -3.547), angle = Angle(84.832, 49.483, 6.363), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["paper"] = {type = "Model", model = "models/props_junk/garbage_newspaper001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.519, 5.426, -2.177), angle = Angle(93.78, 0, 1.71), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

function SWEP:Deploy()
	self:SetDeploySpeed(5)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "Stories")
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self:SetStories(5)
end

function SWEP:CanPrimaryAttack() return true end
function SWEP:CanSecondaryAttack() return false end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	if self:GetStories() > 0 then
		if self:GetStories() == 5 then
			self.Owner:ChatPrint("Let's see what made the news today...")
			self:SetStories(self:GetStories() - 1)
		else
			local people = file.Read("newspaper/people.txt"):Split("\n")
			local places = file.Read("newspaper/places.txt"):Split("\n")
			local headlines = file.Read("newspaper/roots.txt"):Split("\n")
			local headline = headlines[math.random(#headlines)]:Replace("{person}", people[math.random(#people)]):Replace("{person2}", people[math.random(#people)]):Replace("{place}", places[math.random(#places)]):Replace("{place2}", places[math.random(#places)])
			self.Owner:ChatPrint("\"" .. headline .. "\"")
			self:SetStories(self:GetStories() - 1)
		end
	else
		self.Owner:ChatPrint("That was... interesting.")
		self:Remove()
	end
end

if CLIENT then return end

if not file.Exists("newspaper", "DATA") then
	file.CreateDir("newspaper")
	timer.Simple(0.1, function()
		file.Write("newspaper/roots.txt", "{person} wins big on lottery\n{person} falls into volcano, {person2} claims foul play\n{person} stabs four at local {place}\n{person} trapped inside {place}, starves to death\nAfter three decades of business, local {place} shuts down\nHousing prices 'better than ever', says {person}\n{person} proud to announce the 'world's largest {place}'\n{person} arrested in {place}, awaiting trial\nDrug bust at {place} leaves {person} speechless")
		file.Write("newspaper/people.txt", "Florida man\nTwitch streamer\nDoctor\nLawyer\nMillionaire\nHomeless man\nMother of six\nCooking show host\nInternet celebrity\nU.S. President\nPope\nNewly-wed couple\nRoyal family\nHockey legend\nSinger\nAlleged murderer\nWeather man\nPostal worker\nSoldier\nYoung child")
		file.Write("newspaper/places.txt", "museum\nmobile home\nstadium\nmansion\nnightclub\nrestaurant\ncasino\nwaffle house\nsoup kitchen\nparking lot\nstreet corner")
	end)
end
