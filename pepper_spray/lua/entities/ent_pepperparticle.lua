AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Pepper Spray Particle"
ENT.Spawnable = false

if SERVER then
	function ENT:Initialize()
		local size = 1
		self:SetModel("models/Items/AR2_Grenade.mdl") 
		self:PhysicsInitSphere(size, "wood")
		self:SetCollisionBounds(Vector(-size, -size, -size), Vector(size, size, size))
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:DrawShadow(false)
	
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
			phys:EnableGravity(false)
			phys:EnableDrag(true)
			phys:SetMass(1)
		end

		SafeRemoveEntityDelayed(self, 0.5)
	end

	local spray_self = true

	function ENT:Think()
		for _, ply in ipairs(player.GetAll()) do
			if ply:EyePos():DistToSqr(self:GetPos()) <= 500 and (spray_self or ply ~= self:GetOwner()) then
				ply:SetNWFloat("pepper_sprayed", CurTime())
					ply:ViewPunch(Angle(math.random(0, 50), math.random(-30, 30), 0))
				ply.LastPepperSprayCough = ply.LastPepperSprayCough or 0
				if CurTime() - ply.LastPepperSprayCough > 0.8 then
					ply.LastPepperSprayCough = CurTime()
					ply:EmitSound("ambient/voices/cough" .. math.random(4) .. ".wav")
				end
			end
		end
	end
else
	hook.Add("PostDrawHUD", "PepperSpray.PostDrawHUD", function()
		local frac = math.Clamp(0.6 / math.max((CurTime() - LocalPlayer():GetNWFloat("pepper_sprayed")) * 2, 1), 0, 1)
		surface.SetDrawColor(255, 80, 0, frac * 255)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end)

	function ENT:Initialize()
		self.SpawnTime = CurTime()
	end

	local mat = Material("particle/particle_smokegrenade")

	function ENT:Draw()
		local time = CurTime() - self.SpawnTime
		local size = 1 + (time * 8)

		render.SetMaterial(mat)
		render.DrawSprite(self:GetPos(), size, size, Color(255, 120, 20, 255 - (time * 400)))
	end
end
