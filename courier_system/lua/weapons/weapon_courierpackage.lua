AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Package"
SWEP.Category = "Courier System"
SWEP.Instructions = "<color=green>[RELOAD]</color> Drop package.\n\nTake this package to a package collector to earn a reward.\n\n<color=red>Be wary! Carrying this package makes you a good target for thieves.</color>"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.HoldType = "slam"
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.VElements = {
	["box"] = { type = "Model", model = "models/props_junk/cardboard_box004a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.572, 4.65, -1.298), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["box"] = { type = "Model", model = "models/props_junk/cardboard_box004a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.981, 4.376, -1.774), angle = Angle(26.246, 22.854, 14.038), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["v_weapon.c4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

function SWEP:CanPrimaryAttack() return false end
function SWEP:PrimaryAttack() end
function SWEP:CanSecondaryAttack() return false end
function SWEP:SecondaryAttack() end

local hmu_to_m = 52.6

if SERVER then
	function SWEP:Reload()
		if self.Dropped then return end

		local pos = self.Owner:EyePos() + (self.Owner:GetAimVector() * 30)
		if not util.IsInWorld(pos) then return end

		self.Dropped = true

		local dropped = ents.Create("ent_droppedpackage")
		dropped:SetPos(pos)
		dropped:Spawn()

		self.Owner:ConCommand("lastinv")
		self.Owner:StripWeapon(self.ClassName)
	end
else
	SWEP.FoundBuyers = {}

	function SWEP:Think()
		self.FoundBuyers = ents.FindByClass("npc_collector")
		self:SetNextClientThink(CurTime() + 0.5)
		return true
	end

	function SWEP:DrawHUD()
		local us = LocalPlayer():GetPos()
		for k, v in pairs(self.FoundBuyers) do
			if not IsValid(v) then continue end

			local them = v:GetPos() + Vector(0, 0, 76)
			local tab = them:ToScreen()
			draw.SimpleTextOutlined("COLLECTOR", "DermaDefault", tab.x, tab.y, Color(200 + (math.sin(CurTime() * 2) * 50), 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black)
			draw.SimpleTextOutlined(math.ceil(us:Distance(them) / 52.6) .. "M", "DermaDefault", tab.x, tab.y + 14, Color(200 + (math.sin(CurTime() * 2) * 50), 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black)
		end
	end
end
