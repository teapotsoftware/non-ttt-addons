AddCSLuaFile()

sound.Add({
	name = "Weapon_ToyM4A1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 40,
	pitch = {185, 195},
	sound = "garrysmod/balloon_pop_cute.wav"
})

SWEP.Base = "toygun_base_sck"

SWEP.PrintName = "Toy M4A1"
SWEP.Category = "Toy Guns"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "w"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model( "models/weapons/w_rif_m4a1.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_rif_m4a1.mdl" )
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound( "Weapon_ToyM4A1.Single" )
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.1

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

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

SWEP.IronsightsPos = Vector(-7.94, 0, 0)
SWEP.IronsightsAng = Angle(3.164, -1.444, -3.1)

SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.UseIronsightsRecoil = true

SWEP.LoweredPos = Vector(1.6397, -5.089, 4)
SWEP.LoweredAng = Angle(-17.2767, 28.3565, -0.4145)

SWEP.SelectColor = Color(100, 255, 100)

SWEP.ToyGunColored = true

local finger_pull_trigger = Angle(0, -57.409, 0)

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -57.409, 0) }
}

SWEP.VElements = {
	["clip_dart_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.m4_Clip", rel = "", pos = Vector(0.159, -0.55, -0.15), angle = Angle(-3.151, 0, -180), size = Vector(0.057, 0.057, 0.057), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.m4_Parent", rel = "", pos = Vector(0.163, -4.62, -18.574), angle = Angle(-2.161, 0, 0), size = Vector(0.298, 0.298, 0.298), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "clip_dart_body", pos = Vector(0, 0, 0.918), angle = Angle(180, 0, 0), size = Vector(0.019, 0.019, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.976, -7.919, 24.597), angle = Angle(0, 0, 169.481), size = Vector(0.476, 0.476, 0.476), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

function SWEP:ShootEffects()
	self:SendWeaponAnim(ACT_VM_IDLE)
end

if CLIENT then
	function SWEP:PreDrawViewModel(vm, wep, ply)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger12"].angle = LerpAngle(FrameTime() * 20, self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger12"].angle, LocalPlayer():KeyDown(IN_ATTACK) and finger_pull_trigger or angle_zero)
		return self.BaseClass.PreDrawViewModel(self, vm, wep, ply)
	end

	killicon.AddFont("weapon_toy_m4a1", "CSKillIcons", SWEP.IconLetter, Color(100, 255, 100, 255))
end