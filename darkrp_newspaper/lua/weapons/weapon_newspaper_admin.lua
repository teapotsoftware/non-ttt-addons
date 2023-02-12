AddCSLuaFile()

if SERVER then
	util.AddNetworkString("newspaper_edit")

	net.Receive("newspaper_edit", function(len, ply)
		if not ply:IsAdmin() then
			if ply.WarnedAboutNewspaperNetSpam then
				ply:Kick("[DarkRP Newspaper] Net spam will not be tolerated!")
			else
				ply.WarnedAboutNewspaperNetSpam = true
				ply:ChatPrint("YOU ARE NOT AN ADMIN. DO NOT SPAM NEWSPAPER_EDIT. THIS IS YOUR FIRST AND ONLY WARNING - YOU WILL BE KICKED.")
			end
			return
		end
		local kind = net.ReadString()
		local content = net.ReadString()
		if kind == "person" then
			kind = "people"
		else
			kind = kind .. "s"
		end
		file.Append("newspaper/" .. kind .. ".txt", "\n" .. content)
	end)
end

SWEP.Base = "weapon_sck_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.PrintName = "Admin Newspaper"
SWEP.Instructions = "<color=green>[PRIMARY FIRE]</color> Edit newspaper settings"
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
	if not self.Owner:IsAdmin() then
		self.Owner:ChatPrint("You need to be admin to use the Admin Newspaper!")
		self.Owner:StripWeapon(self.ClassName)
	end
end

function SWEP:CanPrimaryAttack() return true end
function SWEP:CanSecondaryAttack() return false end

function SWEP:PrimaryAttack()
	if SERVER or not IsFirstTimePredicted() then return end

	if not self.Owner:IsAdmin() then
		self.Owner:StripWeapon(self.ClassName)
	end

	local function ask_content(kind)
		Derma_StringRequest("Newspaper Menu", "Type in your " .. kind .. ".\n\nUse \"\\n\" to add multiple entries at once." .. Either(kind == "story", "\n\nYou can use \"{person}\" and \"{place}\" as placeholders for random people and places.", ""), "", function(txt)
			net.Start("newspaper_edit")
			net.WriteString(kind)
			net.WriteString(txt)
			net.SendToServer()
		end, nil, "Add this " .. kind, "Cancel")
	end

	local kind = ""
	Derma_Query("What would you like to add?", "Newspaper Menu", "Story", function() ask_content("story") end, "Person", function() ask_content("person") end, "Place", function() ask_content("place") end, "nothing, cancel this", function() end)
end
