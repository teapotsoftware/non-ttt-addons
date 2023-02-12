AddCSLuaFile()

SWEP.Base = "toygun_base_sck"

SWEP.PrintName = "Toy M249"
SWEP.Category = "Toy Guns"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "z"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model( "models/weapons/w_mach_m249para.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_mach_m249para.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound( "Weapon_ToyAK47.Single" )
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 0.09

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.5
SWEP.Spread.IronsightsMod = 0.35
SWEP.Spread.CrouchMod = 0.8
SWEP.Spread.AirMod = 1.5
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 1

SWEP.IronsightsPos = Vector(-5.961, 0, 2.279)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false

SWEP.LoweredPos = Vector(1.6397, -5.089, 4)
SWEP.LoweredAng = Angle(-17.2767, 28.3565, -0.4145)

SWEP.SelectColor = Color(100, 255, 100)

local finger_pull_trigger = -27.234
local bullet_size_norm = Vector(0.048, 0.048, 0.048)
local bullet_size_norm_head = Vector(0.017, 0.017, 0.009)

SWEP.ViewModelBoneMods = {
	["v_weapon.bullet1"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger11"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

SWEP.VElements = {
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0.159, -1.403, 30.354), angle = Angle(0, 0, 0), size = Vector(0.328, 0.328, 0.328), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["dart1_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart1_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart1_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart2_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet2", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart2_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart2_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart3_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet3", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart3_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart3_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart4_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet4", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart4_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart4_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart5_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet5", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart5_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart5_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart6_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet6", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart6_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart6_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart7_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet7", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart7_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart7_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart8_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet8", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart8_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart8_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart9_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet9", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart9_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart9_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart10_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet10", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart10_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart10_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart11_body"] = {type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.bullet11", rel = "", pos = Vector(0, 0.4, 0), angle = Angle(0, 0, -90), size = Vector(0.048, 0.048, 0.048), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["dart11_head"] = {type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart11_body", pos = Vector(0, 0, 0.809), angle = Angle(0, 0, 180), size = Vector(0.017, 0.017, 0.009), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
}

SWEP.WElements = {
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.807, -10.839, 28.179), angle = Angle(-180, 2.395, 10.19), size = Vector(0.368, 0.368, 0.368), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

if CLIENT then
	function SWEP:PreDrawViewModel(vm, wep, ply)
		--self.ViewModelBoneMods["v_weapon.AK47_Bolt"].pos = LerpVector(FrameTime() * 9, self.ViewModelBoneMods["v_weapon.AK47_Bolt"].pos, vector_origin)
		--self.VElements["clip_dart_body+"].pos = LerpVector(FrameTime() * 24, self.VElements["clip_dart_body+"].pos, clipdart_pos_end)
		--self.VElements["clip_dart_body+"].pos.y = math.Approach(self.VElements["clip_dart_body+"].pos.y, clipdart_pos_end.y, FrameTime() * 6)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger11"].angle.y = Lerp(FrameTime() * 14, self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger11"].angle.y, LocalPlayer():KeyDown(IN_ATTACK) and finger_pull_trigger or 0)
		local clip = self:Clip1()
		if clip < 11 then
			for i = 1, 11 do
				local n = 12 - i
				if i > clip and (self:GetReloadTime() - CurTime() > 3.6 or not self:GetReloading()) then
					self.VElements["dart" .. n .. "_body"].size = vector_origin
					self.VElements["dart" .. n .. "_head"].size = vector_origin
				else
					self.VElements["dart" .. n .. "_body"].size = bullet_size_norm
					self.VElements["dart" .. n .. "_head"].size = bullet_size_norm_head
				end
			end
		end
		return self.BaseClass.PreDrawViewModel(self, vm, wep, ply)
	end

	killicon.AddFont("weapon_toy_m249", "CSKillIcons", SWEP.IconLetter, Color(100, 255, 100, 255))
end