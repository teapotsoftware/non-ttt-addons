AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Dropped Package"
ENT.Category = "Courier System"
ENT.Spawnable = true

ENT.GiveWeapon = "weapon_courierpackage"

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/cardboard_box004a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)

		SafeRemoveEntityDelayed(self, 30)
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:HasWeapon(self.GiveWeapon) then
				ply:ChatPrint("You're already carrying a package.")
			else
				ply:Give(self.GiveWeapon)
				self:Remove()
			end
		end
	end
else
	function ENT:Initialize()
		self.CreatedTime = CurTime()
	end

	function ENT:Draw()
		self:DrawModel()
		local ang = EyeAngles()

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)

		cam.Start3D2D(self:GetPos() + Vector(0, 0, 20), ang, 0.35)
			draw.SimpleTextOutlined(self.PrintName .. " (" .. 30 - math.floor(CurTime() - self.CreatedTime) .. "s)", "DermaLarge", 0, 0, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
