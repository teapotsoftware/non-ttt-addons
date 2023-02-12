AddCSLuaFile()

sound.Add({
	name = "Weapon_ToyShotgun.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 40,
	pitch = {185, 195},
	sound = "garrysmod/balloon_pop_cute.wav"
})

SWEP.Base = "toygun_base_sck"

SWEP.PrintName = "Toy Shotgun"
SWEP.Category = "Toy Guns"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "k"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/w_shot_m3super90.mdl")
SWEP.ViewModel = Model("models/weapons/cstrike/c_shot_m3super90.mdl")
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound("Weapon_ToyShotgun.Single")
SWEP.Primary.Recoil = 0.2
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 3
SWEP.Primary.Cone = 0.06
SWEP.Primary.Delay = 0.5

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.25
SWEP.Spread.IronsightsMod = 0.75
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector(-7.658, 0, 3.519)
SWEP.IronsightsAng = Angle( 0, 0, 0 )
SWEP.IronsightsFOV = 0.8

SWEP.LoweredPos = Vector( 1.6397, -5.089, 4 )
SWEP.LoweredAng = Angle( -17.2767, 28.3565, -0.4145 )

SWEP.SelectColor = Color(100, 255, 100)

SWEP.ToyGunColored = true

local finger_pull_trigger = Angle(0, -56.697, 0)
local bullet_size_norm = Vector(0.108, 0.108, 0.108)
local bullet_size_norm_head = Vector(0.037, 0.037, 0.014)
local open_chamber = 3.24

SWEP.ViewModelBoneMods = {
	["v_weapon.M3_SHELL"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.M3_CHAMBER"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 3.236), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -56.697, 0) }
}

SWEP.VElements = {
	["dart_body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.M3_SHELL", rel = "", pos = Vector(0, -0.076, -0.875), angle = Angle(0, 0, 180), size = Vector(0.108, 0.108, 0.057), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0, -4.607, -24.942), angle = Angle(0, 0, 0), size = Vector(0.361, 0.361, 0.361), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["dart_body+"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.089, -4.674, -6.667), angle = Angle(0, 0, 180), size = Vector(0.108, 0.108, 0.108), color = Color(0, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["dart_head+"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart_body+", pos = Vector(0, 0, 1.072), angle = Angle(0, 0, 180), size = Vector(0.037, 0.037, 0.014), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["dart_head"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "dart_body", pos = Vector(0, 0, 1.152), angle = Angle(0, 0, 180), size = Vector(0.037, 0.037, 0.014), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["tip"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(29.351, 0.739, -8.4), angle = Angle(80.375, 0, 0), size = Vector(0.351, 0.351, 0.351), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

function SWEP:Reload()
	if not self:CanReload() then return end

	self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
	self.Owner:DoReloadEvent()
	self:QueueIdle()

	self:SetReloading( true )
	self:SetReloadTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
end

function SWEP:InsertShell()
	self:SetClip1( self:Clip1() + 1 )
	self.Owner:RemoveAmmo( 1, self:GetPrimaryAmmoType() )

	self:SendWeaponAnim( ACT_VM_RELOAD )
	self:QueueIdle()

	self:SetReloadTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
end

function SWEP:ReloadThink()
	if self:GetReloadTime() > CurTime() then return end

	if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() ) > 0
		and not self.Owner:KeyDown( IN_ATTACK ) then
		self:InsertShell()
	else
		self:FinishReload()
	end
end

function SWEP:FinishReload()
	self:SetReloading( false )

	self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
	self:SetReloadTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	self:QueueIdle()
end

if CLIENT then
	function SWEP:PrimaryAttack()
		if not game.SinglePlayer() and not self:CanShoot() then return end
		if IsFirstTimePredicted() or game.SinglePlayer() then
			if self:Clip1() > 1 then
				self.ViewModelBoneMods["v_weapon.M3_CHAMBER"].pos.z = open_chamber
			end
			self.VElements["dart_body+"].pos.y = -4
		end
		return self.BaseClass.PrimaryAttack(self)
	end

	function SWEP:PreDrawViewModel(vm, wep, ply)
		self.ViewModelBoneMods["v_weapon.M3_CHAMBER"].pos.z = Lerp(FrameTime() * 9, self.ViewModelBoneMods["v_weapon.M3_CHAMBER"].pos.z, self:Clip1() > 0 and 0 or open_chamber)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger12"].angle = LerpAngle(FrameTime() * 20, self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger12"].angle, LocalPlayer():KeyDown(IN_ATTACK) and finger_pull_trigger or angle_zero)
		self.VElements["dart_body+"].pos.y = math.Approach(self.VElements["dart_body+"].pos.y, -4.674, FrameTime() * 6)
		if self:Clip1() > 0 then
			self.VElements["dart_body+"].size = bullet_size_norm
			self.VElements["dart_head+"].size = bullet_size_norm_head
		else
			self.VElements["dart_body+"].size = vector_origin
			self.VElements["dart_head+"].size = vector_origin
		end
		return self.BaseClass.PreDrawViewModel(self, vm, wep, ply)
	end

	killicon.AddFont("weapon_toy_shotgun", "CSKillIcons", SWEP.IconLetter, Color(100, 255, 100, 255))
end