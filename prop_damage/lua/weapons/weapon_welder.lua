AddCSLuaFile()

SWEP.PrintName = "Welder"
SWEP.Category = "Prop Damage"
SWEP.Instructions = "<color=green>[PRIMARY FIRE]</color> Repair damaged props."

SWEP.Spawnable = true
SWEP.AdminSpawnable = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"
SWEP.UseHands = true

SWEP.ShootSound = Sound("ambient/energy/spark1.wav")
SWEP.TorchDistance = 8000

function SWEP:Initialize()
	self:SetWeaponHoldType("pistol")
end

function SWEP:Deploy()
	self:SetWeaponHoldType("pistol")
end

function SWEP:CanPrimaryAttack() return true end

function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()

	if tr.HitPos:DistToSqr(self.Owner:EyePos()) > self.TorchDistance then
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	local sparks = EffectData()
	sparks:SetOrigin(tr.HitPos)
	sparks:SetMagnitude(1)
	sparks:SetScale(1)
	sparks:SetRadius(2)
	util.Effect("Sparks", sparks)

	self:SetNextPrimaryFire(CurTime() + 0.2)
	self:EmitSound(self.ShootSound, 37)

	if CLIENT then return end

	local prop = tr.Entity
	if not IsValid(prop) then return end

	if prop:GetClass() == "prop_physics" then
		prop:SetNWInt("propdamage_health", math.min(prop:GetNWInt("propdamage_health") + 1, prop:GetNWInt("propdamage_maxhealth")))
	elseif prop:IsPlayer() or prop:IsNPC() then
		prop:TakeDamage(4, self.Owner, self)
		if prop:IsPlayer() then
			prop:EmitSound("hostage/hpain/hpain" .. math.random(6) .. ".wav")
		end
	end
end

function SWEP:CanSecondaryAttack() return false end
function SWEP:SecondaryAttack() end

if CLIENT then
	function SWEP:DrawHUD()
		local size = ScrW() / 200
		local x, y

		if self.Owner == LocalPlayer() and self.Owner:ShouldDrawLocalPlayer() then
			local tr = util.GetPlayerTrace(self.Owner)
			tr.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_MONSTER + CONTENTS_WINDOW + CONTENTS_DEBRIS + CONTENTS_GRATE + CONTENTS_AUX
			local trace = util.TraceLine(tr)
			local coords = trace.HitPos:ToScreen()
			x, y = coords.x, coords.y
		else
			x, y = ScrW() / 2, ScrH() / 2
		end

		local tr = self.Owner:GetEyeTrace()

		if tr.HitPos:DistToSqr(self.Owner:EyePos()) > self.TorchDistance then
			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawLine(x + size, y + size, x - size, y - size)
			surface.DrawLine(x + size, y - size, x - size, y + size)
		elseif IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_physics" then
			surface.SetDrawColor(0, 255, 0, 255)
			surface.DrawLine(x, y - size, x, y + size)
			surface.DrawLine(x - size, y, x + size, y)
		else
			surface.SetDrawColor(255, 255, 0, 255)
			surface.DrawLine(x + size, y + size, x - size, y - size)
			surface.DrawLine(x + size, y - size, x - size, y + size)
		end
	end

	killicon.AddFont("weapon_welder", "Trebuchet24", SWEP.PrintName, Color(255, 80, 0, 255))
end
