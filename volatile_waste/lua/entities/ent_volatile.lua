AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Volatile Waste"
ENT.Category = "Chemicals"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/CS_militia/paintbucket01.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			local vol = ply:GetNWInt("volatile_waste")
			if vol < 8 then
				if vol < 1 then
					ply:ChatPrint("You will explode violently on death.\nThe more you drink, the bigger the explosion!")
				end

				ply:SetNWInt("volatile_waste", vol + 1)
				ply:EmitSound("npc/barnacle/barnacle_gulp" .. math.random(2) .. ".wav")

				self:Remove()
			else
				ply:ChatPrint("You've drunk enough waste, now go blow someone up!")
			end
		end
	end

	local NextVolatileTick = 0
	hook.Add("Think", "VolatileWaste.Think", function()
		if CurTime() > NextVolatileTick then
			NextVolatileTick = CurTime() + 1

			for _, ply in ipairs(player.GetAll()) do
				if ply:GetNWInt("volatile_waste") < 1 then continue end

				if ply:Health() < 6 then
					ply:Kill()
				else
					ply:SetHealth(ply:Health() - 5)
				end
			end
		end
	end)

	hook.Add("PostPlayerDeath", "VolatileWaste.PostPlayerDeath", function(ply)
		local vol = ply:GetNWInt("volatile_waste")
		if IsValid(ply) and vol > 0 then
			ply:SetNWInt("volatile_waste", 0)
			local pos = ply:GetPos()

			timer.Simple(0.2, function()
				if not IsValid(ply) then
					ply = game.GetWorld()
				end

				ParticleEffect("explosion_huge_h", pos, vector_up:Angle())
				util.ScreenShake(pos, 5, 5, 1, 4000)

				local boom = EffectData()
				boom:SetOrigin(pos)
				util.Effect("explosion", boom)

				util.Decal("Scorch", pos + Vector(0, 0, 16), pos + Vector(0, 0, 160))
				util.Decal("Rollermine.Crater", pos + Vector(0, 0, 16), pos + Vector(0, 0, 160))

				util.BlastDamage(ply, ply, pos, 200 + (40 * vol), 120 + (40 * vol))
			end)
		end
	end)
end
