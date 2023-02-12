AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Package Locator"
SWEP.Category = "Courier System"
SWEP.Instructions = "<color=red>Detects the location of courier packages.</color>"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["Detonator"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.907, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.229, 6.637, -18.904) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.483, 0), angle = Angle(0, -0.988, -3.636) },
	["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(0.978, 0.978, 0.978), pos = Vector(-0.596, 0, 0), angle = Angle(14.833, 0, 0) }
}

SWEP.VElements = {
	["thingy"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.126, 1.707, 3.319), angle = Angle(-83.274, -98.958, 0.857), size = Vector(1.534, 1.534, 1.534), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["scanner"] = { type = "Model", model = "models/props_c17/tv_monitor01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.927, 4.205, -0.38), angle = Angle(-4.362, -135.986, 171.494), size = Vector(0.122, 0.372, 0.449), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["screen"] = {type = "Quad", bone = "ValveBiped.Bip01_Spine4", rel = "scanner", pos = Vector(1.6, 0.878, 0.241), angle = Angle(90, 0, 0), size = 0.13, draw_func = nil}
}

SWEP.WElements = {
	["stick"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.427, 2.078, 1.519), angle = Angle(-66.624, -153.118, -24.546), size = Vector(1.585, 1.585, 1.585), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tv"] = { type = "Model", model = "models/props_c17/tv_monitor01.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(4.256, -0.721, 2.785), angle = Angle(-90, 0, -90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.DetectSound = Sound("buttons/blip2.wav")
SWEP.NextDetection = 0

function SWEP:CanPrimaryAttack() return false end
function SWEP:PrimaryAttack() end
function SWEP:CanSecondaryAttack() return false end
function SWEP:SecondaryAttack() end

if CLIENT then
	SWEP.FoundPackages = {}

	function SWEP:Initialize()
		self.BaseClass.Initialize(self)
		self.VElements["screen"].draw_func = function(wep)
			draw.SimpleText(#wep.FoundPackages .. " packages located...", "DermaDefault", 0, 0, Color(200 + (math.sin(CurTime() * 2) * 50), 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	function SWEP:Think()
		if CurTime() < self.NextDetection then return end
		self.NextDetection = CurTime() + 1.2
		self.FoundPackages = table.Add(ents.FindByClass("weapon_courierpackage"), ents.FindByClass("ent_droppedpackage"))
		local pkgs = #self.FoundPackages
		if self.Owner:HasWeapon("weapon_courierpackage") then
			pkgs = pkgs - 1
		end
		if pkgs > 0 then
			self:EmitSound(self.DetectSound, 50, math.min(60 + (pkgs * 4), 120))
		end
	end

	function SWEP:DrawHUD()
		for k, v in pairs(self.FoundPackages) do
			if not IsValid(v) or v:GetOwner() == LocalPlayer() then continue end

			local tab = (v:GetPos() + Vector(0, 0, 16)):ToScreen()
			draw.SimpleTextOutlined("PACKAGE", "DermaLarge", tab.x, tab.y, Color(200 + (math.sin(CurTime() * 2) * 50), 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black)
		end
	end
end
