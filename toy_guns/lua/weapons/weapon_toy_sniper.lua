AddCSLuaFile()

SWEP.Base = "toygun_base_sck"

SWEP.PrintName = "Toy Sniper"
SWEP.Category = "Toy Guns"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "n"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model( "models/weapons/w_snip_scout.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_snip_scout.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound( "Weapon_ToyAK47.Single" )
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.05
SWEP.Primary.Delay = 0.4

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.25
SWEP.Spread.IronsightsMod = 0.001
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector(-7.5, -5, 2.3)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.25
SWEP.IronsightsSensitivity = 0.125

SWEP.LoweredPos = Vector(1.6397, -5.089, 2.4904)
SWEP.LoweredAng = Angle(-17.2767, 28.3565, -0.4145)

SWEP.SelectColor = Color(100, 255, 100)

SWEP.Scope = Material( "gmod/scope" )
SWEP.ScopeRefract = Material( "gmod/scope-refract" )

SWEP.VElements = {
	["tip"] = {type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0, -3.369, -27.439), angle = Angle(0, 0, 0), size = Vector(0.268, 0.268, 0.268), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["tip"] = {type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1, -9.079, 30.902), angle = Angle(0, 0, 170.815), size = Vector(0.268, 0.268, 0.268), color = Color(255, 110, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}}
}

if SERVER then return end

function SWEP:DrawScope()
	local h = ScrH()
	local w = h * 1.25

	local x, y = ScrW() / 2 - w / 2, ScrH() / 2 - h / 2
	
	render.UpdateRefractTexture()

	surface.SetDrawColor( color_black )
	surface.DrawRect( 0, 0, x, ScrH() )
	surface.DrawRect( x + w, 0, ScrW() - ( x + w ), ScrH() )

	surface.SetMaterial( self.ScopeRefract )
	surface.DrawTexturedRect( x, y, w, h )

	surface.SetMaterial( self.Scope )
	surface.DrawTexturedRect( x, y, w, h )

	surface.DrawLine( 0, ScrH() / 2, ScrW(), ScrH() / 2 )
	surface.DrawLine( ScrW() / 2, 0, ScrW() / 2, ScrH() )
end

function SWEP:DrawHUDBackground()
	if self:GetIronsights() then self:DrawScope() end
end

function SWEP:PreDrawViewModel(vm)
	self.BaseClass.PreDrawViewModel(self, vm)
	if self:GetIronsights() then return true end
end

killicon.AddFont("weapon_toy_sniper", "CSKillIcons", SWEP.IconLetter, Color(100, 255, 100, 255))
