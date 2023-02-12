AddCSLuaFile()

local melons = CreateConVar("cannon_balls_are_melons", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Are cannon balls melons?", 0, 1)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cannon Ball"
ENT.Category = "Cannons"
ENT.Spawnable = true

if SERVER then
	local color_gray = Color(25, 25, 25)
	local color_red = Color(150, 25, 25)

	function ENT:Initialize()
		self:SetModel("models/props_junk/watermelon01.mdl")
		if not melons:GetBool() then
			self:SetMaterial("models/debug/debugwhite")
			if self.FlamingCannonBall then
				self:SetColor(color_red)
			else
				self:SetColor(color_gray)
			end
		end
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)

		if self.FlamingCannonBall and not vFireInstalled then
			self:Ignite(30)
		end
	end

	function ENT:PhysicsCollide(data)
		if self.killmepls or data.Speed < 100 then return end
		util.BlastDamage(self, self.CannonShooter or self, self:GetPos(), 200, 200)
		local boom = EffectData()
		boom:SetOrigin(self:GetPos())
		util.Effect("Explosion", boom)
		util.Decal("Scorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal, self)
		self.killmepls = true
		if vFireInstalled and self.FlamingCannonBall then
			CreateVFire(data.HitEntity, data.HitPos, data.HitNormal, 40)
		end
	end

	function ENT:Think()
		if self.killmepls then
			self:Remove()
		end
	end

	hook.Add("EntityTakeDamage", "Cannons.FireShot", function(ent, dmg)
		local inf = dmg:GetInflictor()
		if vFireInstalled or not IsValid(inf) or not inf.FlamingCannonBall then return end
		if IsValid(ent) then
			if ent:IsPlayer() or ent:IsNPC() then
				ent:Ignite(8)
			else
				ent:Ignite(3)
			end
		end
	end)
else
	killicon.AddFont("ent_cannonball", "Trebuchet24", "Cannon", Color(255, 80, 0, 255))
end
