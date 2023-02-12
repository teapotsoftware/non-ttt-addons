AddCSLuaFile()

local paper_class = CreateConVar("newspaper_box_weapon", "weapon_newspaper", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Which weapon the newspaper box gives you.")

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Newspaper Box"
ENT.Category = "Newspaper"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "PapersLeft")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/PlasticCrate01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)

		self:SetPapersLeft(5)
	end

	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:HasWeapon(paper_class:GetString()) then
				ply:ChatPrint("You already have a newspaper.")
			elseif self:GetPapersLeft() > 0 then
				self:SetPapersLeft(self:GetPapersLeft() - 1)
				ply:Give(paper_class:GetString())
				ply:EmitSound("items/itempickup.wav")
				if self:GetPapersLeft() == 0 then
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
		local papers = self:GetPapersLeft()
		if papers > 0 then
			for i = 1, math.min(papers, 5) do
				local ourang = Angle(ang)
				ourang:RotateAroundAxis(ang:Right(), 270)
				render.Model({model = "models/props_junk/garbage_newspaper001a.mdl", pos = base_pos + (offset * i), angle = ourang})
			end
		end
		self:DrawModel()
	end
end
