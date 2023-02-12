AddCSLuaFile()

SWEP.PrintName = "Homing Missile Launcher"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Fire a missile.

Aim at a target to lock on.]]

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"

SWEP.Primary.Delay = 0.6

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

local ShootSound = Sound("HeadcrabCanister.LaunchSound")

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "LockTarget")
	self:NetworkVar("Float", 0, "LockStart")
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType("rpg")

	if SERVER then
		self.NextTryLock = 0
	else
		self.NextLockBeep = 0
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:ViewPunch(Angle(math.random(16, 20), 0, 0))
	self:ShootEffects()
	self:EmitSound(ShootSound)

	if SERVER then
		local rocket = ents.Create("ent_homingmissile")

		if not IsValid(rocket) then return end

		rocket:SetOwner(self.Owner)
		rocket:SetPos(self.Owner:EyePos() + self.Owner:GetRight() * 20)
		rocket:SetAngles(self.Owner:EyeAngles())
		rocket:Spawn()

		local phys = rocket:GetPhysicsObject()
		if not IsValid(phys) then rocket:Remove() return end

		local target = self:GetLockTarget()
		if IsValid(target) then
			rocket.LockTarget = target
			rocket.LockStrength = math.Clamp((CurTime() - self:GetLockStart()) / 2, 0, 1)
		end

		local velocity = self.Owner:GetAimVector() * 12 + self.Owner:GetUp()
		velocity = velocity * 25000
		phys:ApplyForceCenter(velocity)
	end

	self:TakePrimaryAmmo(1)
end

function SWEP:CanSecondaryAttack()
	return false
end

local function ValidTarget(ent)
	return IsValid(ent) and ((ent:IsPlayer() and ent:Alive()) or ent:IsNPC() or ent:IsVehicle())
end

function SWEP:Think()
	if SERVER then
		local curLock = self:GetLockTarget()
		if IsValid(curLock) and not ValidTarget(curLock) then
			self:SetLockTarget(NULL)
		end

		if isfunction(self.Owner.LagCompensation) then
			self.Owner:LagCompensation(true)
		end
		local target = self.Owner:GetEyeTrace().Entity
		if isfunction(self.Owner.LagCompensation) then
			self.Owner:LagCompensation(false)
		end

		if target ~= self:GetLockTarget() and ValidTarget(target) then
			self:SetLockTarget(target)
			self:SetLockStart(CurTime())
		end
	end

	if CLIENT and IsValid(self:GetLockTarget()) and self.NextLockBeep < CurTime() then
		self.NextLockBeep = CurTime() + 0.2

		local frac = math.Clamp((CurTime() - self:GetLockStart()) / 2, 0, 1)
		self:EmitSound("buttons/blip1.wav", 50 + (frac * 35), 120 + (frac * 20))
	end
end

if SERVER then
	function SWEP:Holster()
		self:SetLockTarget(NULL)
		return true
	end

	function SWEP:Reload()
		if self:DefaultReload(ACT_VM_RELOAD) then
			self:SetLockTarget(NULL)
		end
	end
else
	surface.CreateFont("RocketLauncher.LockFont", {
		font = "Arial",
		size = ScreenScale(7),
		weight = 500,
		bold = true
	})

	function SWEP:DrawHUD()
		local target = self:GetLockTarget()
		if IsValid(target) then
			local pos = (target:GetPos() + target:OBBCenter()):ToScreen()
			local frac = math.Clamp((CurTime() - self:GetLockStart()) / 2, 0, 1)
			local w = ScrW() / 40
			surface.SetDrawColor(255 * frac, 255 * (1 - frac), 0)
			surface.DrawOutlinedRect(pos.x - (w / 2), pos.y - (w / 2), w, w)
			if frac == 1 then
				draw.SimpleText("LOCK", "RocketLauncher.LockFont", pos.x, pos.y - (w / 2), Color(255, 0, 0, math.abs(math.sin(CurTime() * 10)) * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end
		end
	end

	function SWEP:DoDrawCrosshair(x, y)
		local w = ScrW() / 80
		local u = w / 2
		surface.SetDrawColor(255, 255, 255)
		surface.DrawLine(x - w, y - w, x - w, y - w + u)
		surface.DrawLine(x - w, y - w, x - w + u, y - w)
		surface.DrawLine(x + w, y - w, x + w, y - w + u)
		surface.DrawLine(x + w, y - w, x + w - u, y - w)
		surface.DrawLine(x - w, y + w, x - w, y + w - u)
		surface.DrawLine(x - w, y + w, x - w + u, y + w)
		surface.DrawLine(x + w, y + w, x + w, y + w - u)
		surface.DrawLine(x + w, y + w, x + w - u, y + w)
		return true
	end
end
