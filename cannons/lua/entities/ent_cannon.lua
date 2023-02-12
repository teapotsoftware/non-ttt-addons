AddCSLuaFile()

local reload_time = CreateConVar("cannon_reload_time", 3, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Time it takes for a cannon to reload.", 0)
local cluster_amt = CreateConVar("cannon_cluster", 3, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Amount of cannon balls in a cluster.", 1)
local fast_reload_mult = CreateConVar("cannon_speedloader_mult", 0.8, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Reload time multiplier for speedloader. Lower is faster.", 0, 1)
local range_mult = CreateConVar("cannon_range_mult", 2.2, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Force multiplier for range upgrade.", 0)

local yaw_deviance = CreateConVar("cannon_yaw_deviance", 30, FCVAR_ARCHIVE + FCVAR_REPLICATED, "How much shots can deviate from dead center.", 0)
local force_fwd = CreateConVar("cannon_force_forward", 3000, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Forward force on cannon ball shots.", 0)
local force_up = CreateConVar("cannon_force_up", 300, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Upward force on cannon ball shots.", 0)
local shot_force = CreateConVar("cannon_force", 10, FCVAR_ARCHIVE + FCVAR_REPLICATED, "General force of cannon ball shots.", 0)

concommand.Add("cannon_reset_cfg", function(ply, cmd, args)
	if CLIENT or not ply:IsAdmin() then return end
	MsgC(Color(255, 100, 255), "Cannon config reset!\n")
	game.ConsoleCommand("cannon_reload_time 3\ncannon_cluster 3\ncannon_speedloader_mult 0.8\ncannon_range_mult 2.2\ncannon_yaw_deviance 30\ncannon_force_forward 3000\ncannon_force_up 300\ncannon_force 10\ncannon_balls_are_melons 0\n")
end)

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cannon"
ENT.Category = "Cannons"
ENT.Spawnable = true

ENT.IsCannon = true

CANNON_UPGRADE_RELOAD = 1
CANNON_UPGRADE_RANGE = 2
CANNON_UPGRADE_CLUSTER = 4
CANNON_UPGRADE_FIRE = 8

local function HasUpgrade(cannon, upgrade)
	return bit.band(cannon:GetUpgrades(), upgrade) ~= 0
end

local function GetReloadTime(cannon)
	local reload = reload_time:GetFloat()
	if (HasUpgrade(cannon, CANNON_UPGRADE_RELOAD)) then
		reload = reload * fast_reload_mult:GetFloat()
	end
	return reload
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "LastShot")
	self:NetworkVar("Int", 0, "Upgrades")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/de_inferno/cannon_base.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetUseType(CONTINUOUS_USE)

		self:SetLastShot(0)
		self:SetUpgrades(0)

		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 270)
		self:SetAngles(ang)
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() and CurTime() - self:GetLastShot() > GetReloadTime(self) then
			self:SetLastShot(CurTime())
			local ang = self:GetAngles()
			local pos = self:GetPos() + (ang:Right() * 95) + (ang:Up() * 55)
			for i = 1, Either(HasUpgrade(self, CANNON_UPGRADE_CLUSTER), cluster_amt:GetInt(), 1) do
				local shot = ents.Create("ent_cannonball")
				shot.CannonShooter = ply
				shot.FlamingCannonBall = HasUpgrade(self, CANNON_UPGRADE_FIRE)
				shot:SetPos(pos)
				shot:Spawn()
				local mult = Either(HasUpgrade(self, CANNON_UPGRADE_RANGE), range_mult:GetFloat(), 1)
				local force = (self:GetRight() * force_fwd:GetInt() * math.Rand(0.95, 1.05)) + (self:GetUp() * force_up:GetInt() * math.Rand(0.95, 1.05)) + (self:GetForward() * yaw_deviance:GetInt() * math.Rand(-1, 1))
				local phys = shot:GetPhysicsObject()
				if IsValid(phys) then
					phys:ApplyForceCenter(force * shot_force:GetInt() * mult)
				end
			end
			local boom = EffectData()
			boom:SetOrigin(pos)
			util.Effect("explosion", boom, true, true)
		end
	end
else
	local color_green = Color(60, 255, 60)
	local color_cyan = Color(60, 255, 255)
	local color_red = Color(255, 60, 60)

	function ENT:Initialize()
		self:SetRenderBounds(self:OBBMins() - Vector(0, 60, 0), self:OBBMaxs() + Vector(0, 0, 20))
	end

	function ENT:Draw()
		local ang = self:GetAngles()
		local last = self:GetLastShot()
		local reload = GetReloadTime(self)
		local model_pos = self:GetPos()
		if CurTime() - last < reload and reload ~= 0 then
			local offset = (ang:Right() * 6) + (ang:Up() * 1)
			model_pos = self:GetPos() + (offset * -math.abs(math.sin((CurTime() - last) * math.pi * (1 / reload))))
		end
		render.Model({model = "models/props/de_inferno/cannon_gun.mdl", pos = model_pos, angle = ang})

		if HasUpgrade(self, CANNON_UPGRADE_RANGE) then
			local ang2 = Angle(ang)
			ang2:RotateAroundAxis(ang:Up(), 270)
			ang2:RotateAroundAxis(ang:Forward(), -6)
			render.Model({model = "models/weapons/w_snip_awp.mdl", pos = model_pos + (ang:Up() * 35.8), angle = ang2})
		end

		if HasUpgrade(self, CANNON_UPGRADE_CLUSTER) then
			local ang2 = Angle(ang)
			ang2:RotateAroundAxis(ang:Forward(), 84)
			render.Model({model = "models/props_junk/MetalBucket01a.mdl", pos = model_pos + (ang:Up() * 51.5) + (ang:Right() * 100), angle = ang2})
		end

		if HasUpgrade(self, CANNON_UPGRADE_FIRE) then
			local ang2 = Angle(ang)
			ang2:RotateAroundAxis(ang:Up(), 180)
			ang2:RotateAroundAxis(ang:Forward(), -96)
			render.Model({model = "models/Items/BoxFlares.mdl", pos = model_pos + (ang:Up() * 32) + (ang:Right() * -14), angle = ang2})
		end

		self:DrawModel()

		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 180)
		ang:RotateAroundAxis(ang:Forward(), 83)

		local pos = self:GetPos() + (ang:Up() * 38.1) + (ang:Right() * -15)
		local prog = math.Clamp((CurTime() - last) / reload, 0, 1)

		cam.Start3D2D(pos, ang, 0.2)
			if prog < 1 then
				draw.RoundedBox(2, -50, -50, 100, 20, color_red)
			end
			draw.RoundedBox(2, -50, -50, 100 * prog, 20, HasUpgrade(self, CANNON_UPGRADE_RELOAD) and color_cyan or color_green)
		cam.End3D2D()
	end

	killicon.AddFont("ent_cannon", "Trebuchet24", "crushed", Color(255, 80, 0, 255))
end
