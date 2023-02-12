AddCSLuaFile()

sound.Add({
	name = "Weapon_ToyRevolver.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 40,
	pitch = {185, 195},
	sound = "garrysmod/balloon_pop_cute.wav"
})

SWEP.Base = "toygun_base_sck"

SWEP.PrintName = "Toy Revolver"
SWEP.Category = "Toy Guns"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "revolver"

SWEP.WorldModel = Model( "models/weapons/w_357.mdl" )
SWEP.ViewModel = Model( "models/weapons/c_357.mdl" )
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound("Weapon_ToyRevolver.Single")
SWEP.Primary.Recoil = 0.2
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.13

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

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

SWEP.IronsightsPos = Vector(-4.72, 0, 0.6)
SWEP.IronsightsAng = Angle(0.1, -0.201, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false

SWEP.LoweredPos = Vector(3.24, -9.801, -7.881)
SWEP.LoweredAng = Angle(40.2, -10.5, 0)

SWEP.SelectColor = Color(100, 255, 100)
SWEP.SelectFont = "HL2MPTypeDeath"

SWEP.ToyGunColored = true

local finger_pull_trigger = Angle(0, -22.362, 0)
local bullet_size_norm = Vector(0.071, 0.071, 0.056)
local bullet_size_norm_head = Vector(0.021, 0.021, 0.009)
local cyl_spin = Angle(0, -60, 0)

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -22.362, 0) },
	["Cylinder"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 56.883, 0) },
	["Bullet4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["b1_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "Bullet1", rel = "", pos = Vector(0, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.056), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b1_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "b1_body", pos = Vector(0, 0, 0.959), angle = Angle(0, 0, 180), size = Vector(0.021, 0.021, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "Bullet2", rel = "", pos = Vector(0, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.056), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "b2_body", pos = Vector(0, 0, 0.959), angle = Angle(0, 0, 180), size = Vector(0.021, 0.021, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b3_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "Bullet3", rel = "", pos = Vector(0, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.056), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b3_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "b3_body", pos = Vector(0, 0, 0.959), angle = Angle(0, 0, 180), size = Vector(0.021, 0.021, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b4_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "Bullet4", rel = "", pos = Vector(0, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.056), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b4_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "b4_body", pos = Vector(0, 0, 0.959), angle = Angle(0, 0, 180), size = Vector(0.021, 0.021, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b5_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "Bullet5", rel = "", pos = Vector(0, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.056), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b5_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "b5_body", pos = Vector(0, 0, 0.959), angle = Angle(0, 0, 180), size = Vector(0.021, 0.021, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b6_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "Bullet6", rel = "", pos = Vector(0, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.056), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b6_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "b6_body", pos = Vector(0, 0, 0.959), angle = Angle(0, 0, 180), size = Vector(0.021, 0.021, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "Python", rel = "", pos = Vector(0, -0.694, 9.085), angle = Angle(0, 0, 0), size = Vector(0.347, 0.347, 0.347), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.9, -4.924, 13.756), angle = Angle(1.376, 0, 176.199), size = Vector(0.347, 0.347, 0.347), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

if CLIENT then
	function SWEP:PrimaryAttack()
		if not game.SinglePlayer() and not self:CanShoot() then return end
		if IsFirstTimePredicted() or game.SinglePlayer() then
			self.ViewModelBoneMods["Cylinder"].angle = cyl_spin
		end
		return self.BaseClass.PrimaryAttack(self)
	end

	function SWEP:PreDrawViewModel(vm, wep, ply)
		self.ViewModelBoneMods["Cylinder"].angle = LerpAngle(math.min(FrameTime() * 18, 1), self.ViewModelBoneMods["Cylinder"].angle, angle_zero)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger11"].angle = LerpAngle(math.min(FrameTime() * 18, 1), self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger11"].angle, LocalPlayer():KeyDown(IN_ATTACK) and finger_pull_trigger or angle_zero)
		local clip = self:Clip1()
		for i = 1, 6 do
			if i > clip and (self:GetReloadTime() - CurTime() > 1.8 or not self:GetReloading()) then
				self.VElements["b" .. i .. "_body"].size = vector_origin
				self.VElements["b" .. i .. "_head"].size = vector_origin
			else
				self.VElements["b" .. i .. "_body"].size = bullet_size_norm
				self.VElements["b" .. i .. "_head"].size = bullet_size_norm_head
			end
		end
		return self.BaseClass.PreDrawViewModel(self, vm, wep, ply)
	end

	killicon.AddFont("weapon_toy_revolver", "HL2MPTypeDeath", SWEP.IconLetter, Color(100, 255, 100, 255))
end