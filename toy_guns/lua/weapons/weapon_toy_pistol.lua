AddCSLuaFile()

sound.Add({
	name = "Weapon_ToyPistol.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 40,
	pitch = {185, 195},
	sound = "garrysmod/balloon_pop_cute.wav"
})

SWEP.Base = "toygun_base_sck"

SWEP.PrintName = "Toy Pistol"
SWEP.Category = "Toy Guns"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "a"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "pistol"

SWEP.WorldModel = Model( "models/weapons/w_pist_usp.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_pist_usp.mdl" )
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound( "Weapon_ToyPistol.Single" )
SWEP.Primary.Recoil = 0.2
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.13

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12

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

SWEP.IronsightsPos = Vector(-5.86, -0.149, 2.719)
SWEP.IronsightsAng = Angle(-0.301, 0.1, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false

SWEP.LoweredPos = Vector(0, -20, -10)
SWEP.LoweredAng = Angle(70, 0, 0)

SWEP.SelectColor = Color(100, 255, 100)

SWEP.ToyGunColored = true

local finger_pull_trigger = Angle(4.769, -48.169, 0)
local bullet_size_norm = Vector(0.086, 0.086, 0.027)
local bullet_size_norm_head = Vector(0.027, 0.027, 0.009)
local clipdart_pos_start = Vector(-0, -2.5, 0)
local clipdart_pos_end = Vector(-0, -3.7, 0)
local slide_back = Vector(0, 0, 2.4)
local hammer_back = Vector(0, 0, 0.765)

SWEP.ViewModelBoneMods = {
	["v_weapon.USP_Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 1.72), angle = Angle(0, 0, 0) },
	["v_weapon.USP_Hammer"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.765), angle = Angle(0, 0, 0) },
	["v_weapon.USP_Silencer"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(4.769, -48.169, 0) }
}

SWEP.VElements = {
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.USP_Parent", rel = "", pos = Vector(-0.151, -3.731, -6.297), angle = Angle(0, 0, 0), size = Vector(0.259, 0.259, 0.259), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_body+"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.USP_Parent", rel = "", pos = Vector(-0.13, -1.377, -0.621), angle = Angle(0, 0, -180), size = Vector(0.086, 0.086, 0.027), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.USP_Clip", rel = "", pos = Vector(-0.13, -0.311, -0.16), angle = Angle(0, 0, -180), size = Vector(0.086, 0.086, 0.027), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_head+"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "clip_dart_body+", pos = Vector(0, 0, 0.319), angle = Angle(0, 0, -180), size = Vector(0.027, 0.027, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "clip_dart_body", pos = Vector(0, 0, 0.319), angle = Angle(0, 0, -180), size = Vector(0.027, 0.027, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(0.505, -3.829, 7.981), angle = Angle(-5.144, 0, 180), size = Vector(0.259, 0.259, 0.259), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

function SWEP:ShootEffects()
	self:SendWeaponAnim(ACT_VM_IDLE)
end

if CLIENT then
	function SWEP:PrimaryAttack()
		if not game.SinglePlayer() and not self:CanShoot() then return end
		if IsFirstTimePredicted() or game.SinglePlayer() then
			self.ViewModelBoneMods["v_weapon.USP_Slide"].pos = slide_back
			self.ViewModelBoneMods["v_weapon.USP_Hammer"].pos = hammer_back
			self.VElements["clip_dart_body+"].pos = clipdart_pos_start
		end
		return self.BaseClass.PrimaryAttack(self)
	end

	function SWEP:PreDrawViewModel(vm, wep, ply)
		self.ViewModelBoneMods["v_weapon.USP_Slide"].pos = LerpVector(math.min(FrameTime() * 9, 1), self.ViewModelBoneMods["v_weapon.USP_Slide"].pos, vector_origin)
		self.ViewModelBoneMods["v_weapon.USP_Hammer"].pos = LerpVector(math.min(FrameTime() * 9, 1), self.ViewModelBoneMods["v_weapon.USP_Hammer"].pos, vector_origin)
		self.VElements["clip_dart_body+"].pos = LerpVector(math.min(FrameTime() * 18, 1), self.VElements["clip_dart_body+"].pos, clipdart_pos_end)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger11"].angle = LerpAngle(math.min(FrameTime() * 18, 1), self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger11"].angle, LocalPlayer():KeyDown(IN_ATTACK) and finger_pull_trigger or angle_zero)
		if self:Clip1() > 0 then
			self.VElements["clip_dart_body+"].size = bullet_size_norm
			self.VElements["clip_dart_head+"].size = bullet_size_norm_head
		else
			self.VElements["clip_dart_body+"].size = vector_origin
			self.VElements["clip_dart_head+"].size = vector_origin
		end
		return self.BaseClass.PreDrawViewModel(self, vm, wep, ply)
	end

	killicon.AddFont("weapon_toy_pistol", "CSKillIcons", SWEP.IconLetter, Color(100, 255, 100, 255))
end