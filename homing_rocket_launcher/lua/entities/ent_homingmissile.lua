AddCSLuaFile()

local old_lock = CreateConVar("hml_old_homing", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Use the old homing missile method, which nearly never misses.", 0, 1)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Homing Missile"

ENT.Spawnable = false
ENT.Model = "models/weapons/w_missile_closed.mdl"

local SplodeDamage = 150
local SplodeRadius = 600

local color_white = color_white or Color(255, 255, 255)
local color_red = Color(255, 0, 0)

local SpriteMat = Material("sprites/light_glow02_add")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:PhysWake()

		self.Noise = CreateSound(self, "weapons/rpg/rocket1.wav")
		self.Noise:Play()
	end

	function ENT:Detonate()
		if self.BlownUp then return end

		self.Noise:Stop()

		local pos = self:GetPos()
		ParticleEffect("explosion_huge_h", pos, vector_up:Angle())
		util.ScreenShake(pos, 5, 5, 1, 4000)

		local boom = EffectData()
		boom:SetOrigin(pos)
		util.Effect("explosion", boom)

		util.BlastDamage(self, self.Owner, pos, SplodeRadius, SplodeDamage)

		-- really stupid workaround, only DMG_AIRBOAT damages choppers
		for _, ent in ipairs(ents.FindByClass("npc_helicopter")) do
			local dmg_amount = 300 - pos:Distance(ent:GetPos())
			if dmg_amount > 0 then
				local dmg = DamageInfo()
				dmg:SetDamage(dmg_amount)
				dmg:SetDamageType(DMG_AIRBOAT)
				dmg:SetAttacker(self.Owner)
				dmg:SetInflictor(self)
				ent:TakeDamageInfo(dmg)
			end
		end

		self.BlownUp = true
		timer.Simple(0, function()
			if not IsValid(self) then return end
			self:Remove()
		end)
	end

	function ENT:TakeDamage()
		self:Detonate()
	end

	function ENT:PhysicsCollide(data, phys)
		self:Detonate()
		util.Decal("Scorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
		util.Decal("Rollermine.Crater", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
	end

	function ENT:Touch(ent)
		if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
			self.DirectHit = true
			self:Detonate()
		end
	end

	function ENT:Think()
		if IsValid(self.LockTarget) then
			self.LockStrength = self.LockStrength or 1
			local desired = ((self.LockTarget:GetPos() + self.LockTarget:OBBCenter()) - self:GetPos()):Angle()
			local ang = self:GetAngles()
			if old_lock:GetBool() then
				ang = LerpAngle(self.LockStrength / 2, ang, desired)
			else
				local dist = math.max(self:GetPos():Distance(self.LockTarget:GetPos()), 1)
				ang = LerpAngle(math.Clamp(self.LockStrength * (1200 / dist), 0.1, 1), ang, desired)
				-- older, more "realistic" locking system
				-- local rate = self.LockStrength * 40
				-- ang.p = math.ApproachAngle(ang.p, desired.p, rate)
				-- ang.y = math.ApproachAngle(ang.y, desired.y, rate)
				-- ang.r = math.ApproachAngle(ang.r, desired.r, rate)
			end
			self:SetAngles(ang)
		end

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			local amp = IsValid(self.LockTarget) and 0.1 - (self.LockStrength * 0.06) or 0.1
			phys:ApplyForceCenter((self:GetForward() + VectorRand(-amp, amp)) * 16000)
		end
	end
else -- CLIENT
	function ENT:Initialize()
		self.EmitTime = CurTime() + 0.1
		self.Emitter = ParticleEmitter(self:GetPos())
	end

	function ENT:Draw()
		self:DrawModel()
	end

	local color_gray = Color(200, 200, 200)

	function ENT:Think()
		if self.EmitTime <= CurTime() then
			local smoke = self.Emitter:Add("particle/smokesprites_000" .. math.random(9), self:GetPos())
			smoke:SetVelocity(Vector(0, 0, 0))
			smoke:SetDieTime(math.Rand(2, 3))
			smoke:SetStartAlpha(255)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.random(15, 20))
			smoke:SetEndSize(math.random(35, 40))
			smoke:SetRoll(math.Rand(180, 480))
			smoke:SetRollDelta(math.Rand(-3, 3))
			smoke:SetColor(color_gray)
			smoke:SetGravity(Vector(0, 0, -30))
			smoke:SetAirResistance(256)
			self.EmitTime = CurTime() + 0.007
		end
	end

	function ENT:OnRemove()
		self.Emitter:Finish()
	end
end
