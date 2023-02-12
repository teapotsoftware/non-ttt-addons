AddCSLuaFile()

SWEP.Base = "lite_base_sck"

SWEP.PrintName = "Dual Desert Eagles"
SWEP.Category = "Lite Weapons (Akimbo)"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "f"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "duel"

SWEP.WorldModel = Model( "models/weapons/w_pist_deagle.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_pist_deagle.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil = 9
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Delay = 0.12

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 14
SWEP.Primary.DefaultClip = 14

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

SWEP.IronsightsPos = Vector(-0.24, 0, 2.2)
SWEP.IronsightsAng = Angle(0.699, 0.8, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = true
SWEP.UseIronsightsRecoil = false

SWEP.LoweredPos = Vector(-0.08, 0, 0.319)
SWEP.LoweredAng = Angle(-19, -0.401, 0)

SWEP.Akimbo = false

if CLIENT then
	killicon.AddFont( "lite_dual_deagles", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

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
	["gun_left"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.232, 3.203, -0.225), angle = Angle(90, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bullet_left+"] = { type = "Model", model = "models/weapons/shell.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "mag_left+", pos = Vector(0, 0, -2.201), angle = Angle(0, 0, 0), size = Vector(0.735, 0.735, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["mag_left+"] = { type = "Model", model = "models/props_lab/harddrive02.mdl", bone = "v_weapon.magazine_right", rel = "", pos = Vector(0.006, -1.644, 0.56), angle = Angle(90, 90, 0), size = Vector(0.085, 0.12, 0.182), color = Color(45, 45, 45, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["gun_right"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0.1, 3.552, 0.162), angle = Angle(90, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["mag_left"] = { type = "Model", model = "models/props_lab/harddrive02.mdl", bone = "v_weapon.magazine_left", rel = "", pos = Vector(-0.156, -1.803, 0), angle = Angle(90, 90, 0), size = Vector(0.085, 0.12, 0.182), color = Color(45, 45, 45, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["bullet_left"] = { type = "Model", model = "models/weapons/shell.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "mag_left", pos = Vector(0, 0, -2.201), angle = Angle(0, 0, 0), size = Vector(0.735, 0.735, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["gun_left"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.98, 1.116, -2.81), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun_right"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.072, 1.473, 2.703), angle = Angle(180, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
