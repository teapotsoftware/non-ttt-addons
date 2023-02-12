
local PLAYER = FindMetaTable("Player")

function PLAYER:GetDrunk()
	return self:GetNWInt("drunkenness", 0)
end

if SERVER then
	function PLAYER:SetDrunk(amt)
		return self:SetNWInt("drunkenness", amt)
	end

	function PLAYER:AddDrunk(amt)
		return self:SetDrunkenness(self:GetDrunkenness() + amt)
	end

	function PLAYER:MakeSober()
		return self:SetDrunkenness(0)
	end
else
	hook.Add("RenderScreenspaceEffects", "DrunkenMotionBlur", function()
		local drunk = LocalPlayer():GetDrunk()
		if drunk > 0 then
			local frac = math.Clamp(drunk, 0, 100) / 500
			DrawMotionBlur(0.1, 0.7, frac)
		end
	end)
end
