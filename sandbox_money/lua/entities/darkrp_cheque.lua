AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cheque"
ENT.Spawnable = false

ENT.IsSpawnedMoney = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "amount")
    self:NetworkVar("Entity", 0, "Writer")
    self:NetworkVar("Entity", 1, "Recipient")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_lab/clipboard.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:PhysWake()

		self.nodupe = true
	end

	function ENT:Use(ply, caller)
		if self.USED or (ply ~= self:GetRecipient() and ply ~= self:GetWriter()) then return end

		self.USED = true
		local amount = self:Getamount()

		ply:addMoney(amount or 0)
		ply:ChatPrint("You cashed a check for " .. DarkRP.formatMoney(amount) .. ".")

		self:Remove()
	end

	function ENT:OnTakeDamage(dmg)
		self:TakePhysicsDamage(dmg)
	end
else
	ENT.TextColors = {
		OtherToSelf = Color(0, 255, 0, 255),
		SelfToSelf = Color(255, 255, 0, 255),
		SelfToOther = Color(0, 0, 255, 255),
		OtherToOther = Color(255, 0, 0, 255)
	}

	function ENT:Draw()
		self:DrawModel()

		local owner = self:GetWriter()
		local recipient = self:GetRecipient()
		local ownerplayer = owner:IsPlayer()
		local recipientplayer = recipient:IsPlayer()
		local localplayer = LocalPlayer()

		local pos = self:GetPos()
		local ang = self:GetAngles()

		pos:Add(ang:Up() * 0.9)

		local text = "Pay: " .. (recipientplayer and recipient:Nick() or "Unknown") .. "\n" .. DarkRP.formatMoney(self:Getamount()) .. "\nSigned: " .. (ownerplayer and owner:Nick() or "Unknown")

		cam.Start3D2D(pos, ang, 0.1)
			local color = localplayer:IsValid() and (ownerplayer and localplayer == owner and (recipientplayer and localplayer == recipient and self.TextColors.SelfToSelf or self.TextColors.SelfToOther) or recipientplayer and localplayer == recipient and self.TextColors.OtherToSelf) or self.TextColors.OtherToOther
			draw.DrawText(text, "ChatFont", 0, -25, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
