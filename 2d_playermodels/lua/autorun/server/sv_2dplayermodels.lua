
util.AddNetworkString("2dplayermodel_update")
util.AddNetworkString("2dplayermodel_remove")
util.AddNetworkString("2dplayermodel_menu")
util.AddNetworkString("2dplayermodel_report")

local PLAYER = FindMetaTable("Player")

function PLAYER:Set2DPlayerModel(mdl, w, h)
	self:SetNWString("2dplayermodel", mdl)
	if not mdl or mdl == "" then
		self:SetRenderMode(RENDERMODE_NORMAL)
		self:DrawShadow(true)
	else
		self:SetNWString("2dplayermodel_height", math.Clamp(h or 80, 50, 90))
		self:SetNWString("2dplayermodel_width", math.Clamp(w or 60, 30, 70))
		self:SetRenderMode(RENDERMODE_ENVIROMENTAL)
		self:DrawShadow(false)
	end
end

local function AntiLag(ply)
	ply.last_2dpm_packet = ply.last_2dpm_packet or 0
	if CurTime() - ply.last_2dpm_packet < 2 then
		ply.last_2dpm_packet = CurTime()
		if ply.last_2dpm_warning and CurTime() - last_2dpm_warning < 15 then
			ply:Kick("Trying to lag the server")
		else
			ply.last_2dpm_warning = CurTime()
			ply:ChatPrint("You are sending requests too fast. You will be kicked!")
		end
		return true
	end
	return false
end

net.Receive("2dplayermodel_update", function(len, ply)
	if AntiLag(ply) then return end

	local pm = net.ReadString()
	if pm == "" then return end

	local height = net.ReadUInt(8)
	local width = net.ReadUInt(8)

	ply:Set2DPlayerModel(pm, width, height)
end)

net.Receive("2dplayermodel_remove", function(len, ply)
	ply:Set2DPlayerModel("")
end)

local problems = {
	"hard to see",
	"nudity",
	"offensive",
	"personal info"
}

net.Receive("2dplayermodel_report", function(len, ply)
	if AntiLag(ply) then return end

	local url = net.ReadString()
	local problem = problems[math.Clamp(net.ReadInt(5), 1, 3)]
	for _, ply in ipairs(player.GetAll()) do
		if ply:IsAdmin() then
			ply:ChatPrint("[2DPM] Player " .. ply:Nick() .. " reported \"" .. url .. "\" (" .. problem .. ")")
		end
	end
end)
