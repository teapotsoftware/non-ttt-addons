AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Gib"

ENT.Spawnable = true
ENT.Models = {"models/Gibs/HGIBS_rib.mdl", "models/Gibs/HGIBS_scapula.mdl", "models/Gibs/HGIBS_spine.mdl", "models/Gibs/HGIBS_rib.mdl", "models/Gibs/HGIBS_scapula.mdl", "models/Gibs/HGIBS_spine.mdl", "models/props_junk/Shoe001a.mdl", "models/props_junk/garbage_metalcan001a.mdl"}


function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Models[math.random(#self.Models)])
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:PhysWake()

		SafeRemoveEntityDelayed(self, 8)
	else
		self.Emitter = ParticleEmitter(self:GetPos())
	end
end

if SERVER then
	function ENT:PhysicsCollide(data, phys)
		if data.Speed > 50 then
			util.Decal("Blood", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			if data.Speed > 100 then
				sound.Play("physics/flesh/flesh_squishy_impact_hard" .. math.random(4) .. ".wav", data.HitPos, 50, math.random(110, 120))
			end
		end
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
		do return true end
		local part = self.Emitter:Add(tex, pos)

		part:SetVelocity(VectorRand() * math.Rand(3, 4))
		part:SetDieTime(20)

		part:SetStartAlpha(255)
		part:SetEndAlpha(100)

		part:SetStartSize(math.random(10, 15))
		part:SetEndSize(math.random(5, 10))

		part:SetColor(math.random(120, 130), 0, 0)
		part:SetCollide(true)
		part:SetGravity(Vector(0, 0, -450))
		part:SetRollDelta(math.random(-10, 10))

		part:SetCollideCallback(function(part)
			part:SetEndSize(math.random(14, 20))
			part:SetEndAlpha(0)
			part:SetDieTime(3)
		end)

		self:SetNextThink(CurTime() + 0.1)
		return true
	end
end
