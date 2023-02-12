AddCSLuaFile()

sound.Add({
	name = "Weapon_ToyAK47.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 40,
	pitch = {185, 195},
	sound = "garrysmod/balloon_pop_cute.wav"
})

SWEP.Base = "toygun_base_sck"

SWEP.PrintName = "Toy AK-47"
SWEP.Category = "Toy Guns"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "b"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model( "models/weapons/w_rif_ak47.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound( "Weapon_ToyAK47.Single" )
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

SWEP.IronsightsPos = Vector(-6.6, -13.12, 2.72)
SWEP.IronsightsAng = Angle(2.309, 0.019, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false

SWEP.LoweredPos = Vector(1.6397, -5.089, 4)
SWEP.LoweredAng = Angle(-17.2767, 28.3565, -0.4145)

SWEP.SelectColor = Color(100, 255, 100)

SWEP.ToyGunColored = true

local finger_pull_trigger = Angle(10.498, -72.778, 0)
local bullet_size_norm = Vector(0.067, 0.067, 0.067)
local bullet_size_norm_head = Vector(0.023, 0.023, 0.009)
local clipdart_pos_end = Vector(0, -5.511, -6.554)

SWEP.ViewModelBoneMods = {
	["v_weapon.AK47_Bolt"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["clip_dart_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.AK47_Clip", rel = "", pos = Vector(0.079, -0.399, 0.653), angle = Angle(0, -3.408, 180), size = Vector(0.067, 0.067, 0.067), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "clip_dart_body", pos = Vector(0, 0, 0.981), angle = Angle(0, 0, -180), size = Vector(0.023, 0.023, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["tip"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -3.75, -28.5), angle = Angle(0, 0, -2), size = Vector(0.043, 0.043, 0.083), color = Color(255, 128, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_body+"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -5.511, -6.554), angle = Angle(0, -3.408, 180), size = Vector(0.067, 0.067, 0.067), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["clip_dart_head+"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "clip_dart_body+", pos = Vector(0, 0, 0.981), angle = Angle(0, 0, -180), size = Vector(0.023, 0.023, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["tip"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.063, -8, 28.475), angle = Angle(0, 0, -10.421), size = Vector(0.052, 0.052, 0.052), color = Color(255, 128, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

if CLIENT then
	function SWEP:PrimaryAttack()
		if not game.SinglePlayer() and not self:CanShoot() then return end
		if IsFirstTimePredicted() or game.SinglePlayer() then
			self.ViewModelBoneMods["v_weapon.AK47_Bolt"].pos = Vector(0, 0, 5)
			self.VElements["clip_dart_body+"].pos.y = -4.75
		end
		return self.BaseClass.PrimaryAttack(self)
	end

	function SWEP:PreDrawViewModel(vm, wep, ply)
		self.ViewModelBoneMods["v_weapon.AK47_Bolt"].pos = LerpVector(FrameTime() * 9, self.ViewModelBoneMods["v_weapon.AK47_Bolt"].pos, vector_origin)
		--self.VElements["clip_dart_body+"].pos = LerpVector(FrameTime() * 24, self.VElements["clip_dart_body+"].pos, clipdart_pos_end)
		self.VElements["clip_dart_body+"].pos.y = math.Approach(self.VElements["clip_dart_body+"].pos.y, clipdart_pos_end.y, FrameTime() * 6)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger12"].angle = LerpAngle(FrameTime() * 14, self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger12"].angle, LocalPlayer():KeyDown(IN_ATTACK) and finger_pull_trigger or angle_zero)
		if self:Clip1() > 0 then
			self.VElements["clip_dart_body+"].size = bullet_size_norm
			self.VElements["clip_dart_head+"].size = bullet_size_norm_head
		else
			self.VElements["clip_dart_body+"].size = vector_origin
			self.VElements["clip_dart_head+"].size = vector_origin
		end
		return self.BaseClass.PreDrawViewModel(self, vm, wep, ply)
	end

	killicon.AddFont("weapon_toy_ak47", "CSKillIcons", SWEP.IconLetter, Color(100, 255, 100, 255))
end
