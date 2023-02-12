AddCSLuaFile()

local cook_time = CreateConVar("meth_cooktime", 80, FCVAR_ARCHIVE, "Time it takes meth to cook.", 0)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Pot"
ENT.Category = "Meth Equipment"
ENT.Spawnable = true

local function IsOnStove(pot)
	for _, ent in pairs(ents.FindInSphere(pot:GetPos(), 12)) do
		if ent.IsMethStove then
			local can = ent:GetCanister()
			if can ~= NULL and can:GetFuel() > 0 then
				pot:SetStove(ent)
				return true
			end
		end
	end
end

local function CanCook(pot)
	return pot:GetIngredientsNeeded() < 1 and IsOnStove(pot)
end

local function DoneCooking(pot)
	return pot:GetCookingProgress() >= 100
end

local function ResetCooking(pot)
	pot:SetIsCooking(false)
	pot:SetWhenToAdd(CurTime() + math.random(6, 9))
	pot:SetCookingProgress(0)
	pot:SetIngredientsNeeded(math.random(5, 7))
	pot:SetNextIngredient(math.random(3))
end

local function Cough(ply)
	ply:EmitSound("ambient/voices/cough" .. math.random(4) .. ".wav")
	ply:ViewPunch(Angle(math.random(10, 15), 0, 0))
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsCooking")
	self:NetworkVar("Int", 0, "CookingProgress")
	self:NetworkVar("Int", 1, "NextIngredient")
	self:NetworkVar("Int", 2, "IngredientsNeeded")
	self:NetworkVar("Int", 3, "WhenToAdd")
	self:NetworkVar("Entity", 0, "Stove")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/metalPot001a.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()

		ResetCooking(self)
		
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 90)
		self:SetAngles(ang)
	end

	function ENT:StartTouch(ent)
		if IsValid(ent) and ent.MethIngredient then
			local snd = "ambient/levels/canals/toxic_slime_sizzle" .. math.random(3) + 1 .. ".wav"
			if ent.MethIngredient == self:GetNextIngredient() and CurTime() > self:GetWhenToAdd() then
				self:SetWhenToAdd(CurTime() + math.random(6, 9))
				self:SetIngredientsNeeded(self:GetIngredientsNeeded() - 1)
				self:SetNextIngredient(math.random(3))
				self:EmitSound(snd, 72)
			else
				self:EmitSound(snd, 90, math.random(140, 160))
				self.GoingBoom = true
			end

			local smoke = EffectData()
			smoke:SetStart(self:GetPos())
			smoke:SetOrigin(self:GetPos() + Vector(0, 0, 8))
			smoke:SetScale(8)
			util.Effect("GlassImpact", smoke, true, true)

			ent:Remove()
		end
	end

	function ENT:Think()
		if self.GoingBoom then
			util.BlastDamage(self, self, self:GetPos(), 200, 90)
			local boom = EffectData()
			boom:SetOrigin(self:GetPos() + Vector(0, 0, 5))
			util.Effect("explosion", boom)
			self:Remove()
			return
		end

		if CanCook(self) and not DoneCooking(self) then
			self:SetCookingProgress(math.Clamp(self:GetCookingProgress() + 1, 0, 100))
			local can = self:GetStove():GetCanister()
			can:SetFuel(math.Clamp(can:GetFuel() - 1, 0, 200))
			if math.random(2) == 1 then
				self:EmitSound("ambient/levels/canals/toxic_slime_gurgle" .. math.random(7) + 1 .. ".wav", 60)
			end
			for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 80)) do
				if IsValid(ent) and ent:IsPlayer() and math.random(7) == 1 then
					Cough(ent)
				end
			end
			self:SetIsCooking(true)
		else
			self:SetIsCooking(false)
		end

		self:NextThink(CurTime() + 0.8)
		return true
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() and DoneCooking(self) then
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle" .. math.random(3) + 1 .. ".wav", 72)
			ResetCooking(self)
			local meth = ents.Create("ent_meth")
			meth:SetPos(self:GetPos() + Vector(0, 0, 26))
			meth:Spawn()
			ply:ChatPrint("The meth is done! " .. (DarkRP and "Take it to an addict to sell it OR s" or "S") .. "hoot it to break it into ingestible chunks.")
		end
	end
else
	local ReadableIngredient = {"Caustic Soda", "Muriatic Acid", "Hydrogen Chloride"}

	local color_red = Color(255, 60, 60)
	local color_green = Color(60, 255, 60)

	function ENT:Initialize()
		self.EmitTime = CurTime()
		self.FirePlace = ParticleEmitter(self:GetPos())
	end

	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()
		local ang = self:GetAngles()

		ang:RotateAroundAxis(ang:Forward(), 90)

		cam.Start3D2D(pos + (ang:Up() * 7.5) + (ang:Right() * -2), ang, 0.12)
			local prog = self:GetCookingProgress()
			local cooking = prog > 0
			draw.RoundedBox(2, -50, -30, 100, 30, color_red)
			if cooking then
				draw.RoundedBox(2, -50, -30, self:GetCookingProgress(), 30, color_green)
			end
			draw.SimpleText("Progress", "Trebuchet24", 0, -28,  color_white, TEXT_ALIGN_CENTER)
			if cooking then
				draw.SimpleText(prog == 100 and "Done!" or "Cooking...", "Trebuchet24", 0, 8,  color_white, TEXT_ALIGN_CENTER)
			elseif CurTime() > self:GetWhenToAdd() then
				draw.SimpleText("Add " .. ReadableIngredient[self:GetNextIngredient()], "Trebuchet24", 0, 8,  color_white, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("Wait...", "Trebuchet24", 0, 8,  color_white, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end

	function ENT:Think()
		if self.EmitTime <= CurTime() and self:GetIsCooking() then
			local smoke = self.FirePlace:Add("particle/smokesprites_000" .. math.random(9), self:GetPos())
			smoke:SetVelocity(Vector(0, 0, 150))
			smoke:SetDieTime(math.Rand(0.6, 2.3))
			smoke:SetStartAlpha(math.Rand(150, 200))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.random(0, 5))
			smoke:SetEndSize(math.random(33, 55))
			smoke:SetRoll(math.Rand(180, 480))
			smoke:SetRollDelta(math.Rand(-3, 3))
			smoke:SetColor(50, 100 + math.random(-10, 10), 125 + math.random(-10, 10))
			smoke:SetGravity(Vector(0, 0, 10))
			smoke:SetAirResistance(256)
			self.EmitTime = CurTime() + 0.1
		end
	end
end
