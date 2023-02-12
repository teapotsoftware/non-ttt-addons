AddCSLuaFile()

game.AddAmmoType({
	name = "pepperspray",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
})

if CLIENT then
	language.Add("pepperspray_ammo", "Pepper Spray")
end

SWEP.PrintName = "Pepper Spray"
SWEP.Category = "Self Defense"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Spray pepper.]]

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pepperspray"

SWEP.Primary.Delay = 0.1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

local ShootSound = Sound("player/sprayer.wav")

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType("pistol")
end

function SWEP:CanPrimaryAttack()
	return self.Owner:GetAmmoCount(self.Primary.Ammo) > 0
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:ShootEffects()
	self:TakePrimaryAmmo(1)
	self:EmitSound(ShootSound)

	if CLIENT then return end

	local ent = ents.Create("ent_pepperparticle")
	if not IsValid(ent) then return end

	ent:SetPos(self.Owner:EyePos())
	ent:SetAngles(self.Owner:EyeAngles())
	ent:SetOwner(self.Owner)
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if not IsValid(phys) then ent:Remove() return end

	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 200
	velocity = velocity + (VectorRand() * 10)
	phys:ApplyForceCenter(velocity)
end

function SWEP:CanSecondaryAttack()
	return false
end
