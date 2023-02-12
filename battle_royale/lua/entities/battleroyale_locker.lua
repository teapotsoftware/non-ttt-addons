AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Queue Locker"
ENT.Category = "Battle Royale"
ENT.Spawnable = true

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end

	self:PhysWake()
end

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:TryQueueBR()
		end
	end
else
	function ENT:Draw()
		self:DrawModel()

		local Ang = self:GetAngles()
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		local is_queued = LocalPlayer():IsBRStatus(BR_STATUS_QUEUE)
		local time = isfunction(BattleRoyale.GetTimer) and "Starting in " .. BattleRoyale.GetTimer() or "Starting any time now"

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 30) + (self:GetForward() * 20), Ang, 0.35)
			draw.SimpleTextOutlined("Battle Royale", "Trebuchet24", 0, 0, Color(255, 0,0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
			draw.SimpleTextOutlined(is_queued and "In queue" or "Queue up to play", "Trebuchet24", 0, 40, Color(255, 0,0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
			-- draw.SimpleTextOutlined(time, "Trebuchet24", 0, 80, Color(255, 0,0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
