AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Spawned Money"
ENT.Spawnable = false

ENT.IsSpawnedMoney = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "amount")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/cs_assault/money.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:PhysWake()

		self.nodupe = true
	end

	function ENT:Use(ply, caller)
		if self.USED or self.hasMerged then return end

		self.USED = true
		local amount = self:Getamount()

		hook.Call("playerPickedUpMoney", nil, ply, amount or 0, self)

		ply:addMoney(amount or 0)
		ply:ChatPrint("You picked up " .. DarkRP.formatMoney(amount) .. ".")

		self:Remove()
	end

	function ENT:OnTakeDamage(dmg)
		self:TakePhysicsDamage(dmg)
	end

	function ENT:StartTouch(ent)
		if (not ent.IsSpawnedMoney) or self.USED or ent.USED or self.hasMerged or ent.hasMerged then return end

		ent.USED = true
		ent.hasMerged = true

		self:Setamount(self:Getamount() + ent:Getamount())

		ent:Remove()
	end
else
	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()
		local ang = self:GetAngles()

		surface.SetFont("ChatFont")
		local text = DarkRP.formatMoney(self:Getamount())
		local TextWidth = surface.GetTextSize(text)

		cam.Start3D2D(pos + ang:Up() * 0.84, ang, 0.1)
			draw.WordBox(2, -TextWidth * 0.5, -10, text, "ChatFont", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
		cam.End3D2D()

		ang:RotateAroundAxis(ang:Right(), 180)

		cam.Start3D2D(pos, ang, 0.1)
			draw.WordBox(2, -TextWidth * 0.5, -10, text, "ChatFont", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
		cam.End3D2D()
	end

	function ENT:Think()
	end
end
