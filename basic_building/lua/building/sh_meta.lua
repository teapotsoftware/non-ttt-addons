
local PLAYER = FindMetaTable("Player")

function PLAYER:GetResources()
	return self:GetNWInt("building_resources", 0)
end

if SERVER then
	function PLAYER:SetResources(amt)
		self:SetNWInt("building_resources", amt)
	end

	function PLAYER:AddResources(amt)
		self:SetResources(self:GetResources() + amt)
		self:ChatPrint("+" + string.Comma(amt) + " resources")
	end

	function PLAYER:SubtractResources(amt)
		self:AddResources(-amt)
		self:ChatPrint("-" + string.Comma(amt) + " resources")
	end
end
