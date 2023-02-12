AddCSLuaFile()

SWEP.Base = "lite_base_sck"

SWEP.PrintName = "Dual Mac-10s"
SWEP.Category = "Lite Weapons (Akimbo)"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "l"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound("Weapon_MAC10.Single")
SWEP.Primary.Recoil = 2
SWEP.Primary.Damage = 11
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.045

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 60
SWEP.Primary.DefaultClip = 60

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.25
SWEP.Spread.IronsightsMod = 0.2
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector(0, -3, 0)
SWEP.IronsightsAng = Angle(4, 0, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = true

SWEP.LoweredPos = Vector(-0.08, 0, 0.319)
SWEP.LoweredAng = Angle(-19, -0.401, 0)

if CLIENT then
	killicon.AddFont("lite_dual_mac10s", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["v_weapon.elite_right"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.elite_left"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["gun_left"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.239, 4.163, 0.014), angle = Angle(90, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun_right"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(-0.299, 4.191, 0.162), angle = Angle(90, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["gun_left"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.821, 1.437, -3.605), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun_right"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.729, 0.816, 3.644), angle = Angle(180, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

