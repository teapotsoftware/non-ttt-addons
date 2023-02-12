
local gore_particles_speed = CreateConVar("gore_particles_speed", 3, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Speed of gore particles.", 0)
local gore_particles_min = CreateConVar("gore_particles_min", 6, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Minimum amount of gore particles.", 0)
local gore_particles_max = CreateConVar("gore_particles_max", 9, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maximum amount of gore particles.", 0)

local tex = "effects/blood_core"
EFFECT.Mat = Material(tex)

local function KillPart(part)
	part:SetEndSize(math.random(14, 20))
	part:SetEndAlpha(0)
	part:SetDieTime(3)
end

local function DecalMaker(part, pos, norm)
	KillPart(part)
	util.Decal("Blood", pos + norm, pos - norm)
	sound.Play("physics/flesh/flesh_squishy_impact_hard" .. math.random(4) .. ".wav", pos, 50, math.random(110, 120))
end

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	if not pos then return false end
	sound.Play("physics/flesh/flesh_squishy_impact_hard" .. math.random(4) .. ".wav", pos)
	self.Emitter = ParticleEmitter(pos)

	for i = 1, math.random(gore_particles_min:GetInt(), gore_particles_max:GetInt()) do
		local part = self.Emitter:Add(tex, pos)

		part:SetVelocity(VectorRand() * math.Rand(40, 50) * (1 + (gore_particles_speed:GetFloat() * 0.1)))
		part:SetDieTime(20)

		part:SetStartAlpha(255)
		part:SetEndAlpha(100)

		part:SetStartSize(math.random(10, 15))
		part:SetEndSize(math.random(5, 10))

		part:SetColor(math.random(120, 130), 0, 0)
		part:SetCollide(true)
		part:SetGravity(Vector(0, 0, -450))
		part:SetRollDelta(math.random(-10, 10))
		if i < 14 then
			part:SetCollideCallback(DecalMaker)
		else
			part:SetCollideCallback(KillPart)
		end
	end
end

function EFFECT:Think() end
function EFFECT:Render() end
