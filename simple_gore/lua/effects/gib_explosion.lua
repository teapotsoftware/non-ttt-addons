
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

	for i = 1, math.random(50, 60) do
		local part = self.Emitter:Add(tex, pos)

		part:SetVelocity(VectorRand() * math.Rand(40, 50) * 6)
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
