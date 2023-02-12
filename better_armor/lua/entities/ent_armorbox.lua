AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Armor Box"
ENT.Category = "Armor"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ArmorPlates")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/PlasticCrate01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)

		self:SetArmorPlates(5)
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:Armor() >= 100 then
				ply:ChatPrint("You already have armor.")
			elseif self:GetArmorPlates() > 0 then
				self:SetArmorPlates(self:GetArmorPlates() - 1)
				ply:SetArmor(100)
				ply:EmitSound("items/itempickup.wav")
				if self:GetArmorPlates() == 0 then
					self:Remove()
				end
			end
		end
	end
else
	local offset_ang = Angle(90, 0, 0)

	function ENT:Draw()
		local ang = self:GetAngles()
		local base_pos = self:GetPos() + (ang:Forward() * -9.2) + (ang:Up() * 5) + (ang:Right() * -1)
		local offset = ang:Forward() * 3
		local plates = self:GetArmorPlates()
		if plates > 0 then
			for i = 1, math.min(plates, 5) do
				local ourang = Angle(ang)
				ourang:RotateAroundAxis(ang:Right(), 270)
				render.Model({model = "models/props_junk/garbage_newspaper001a.mdl", pos = base_pos + (offset * i), angle = ourang})
			end
		end
		self:DrawModel()
	end
end
