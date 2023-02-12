
local dir = "2d_playermodels"
file.CreateDir(dir)

local error_mat = Material("materials/icon16/cancel.png", "nocull")
local loading_mat = Material("materials/icon16/hourglass.png", "nocull")
local mats = {}

concommand.Add("2dpm_reload", function()
	mats = {}
end)

concommand.Add("2dpm_clearcache", function()
	local files = file.Find(dir .. "/*", "DATA")
	for _, fil in ipairs(files) do
		print("Clearing " .. dir .. "/" .. fil)
		file.Delete(dir .. "/" .. fil)
	end
	mats = {}
end)

local function TryLoadMat(name)
	local mat = Material(name, "nocull")
	if mat:IsError() then
		return error_mat
	end
	return mat
end

local function Fetch2DPM(url)
	if not url or url == "" then return error_mat end

	if mats[url] then
		return mats[url]
	end

	local exten = string.GetExtensionFromFilename(url)
	if not exten then return error_mat end

	if exten == "jpeg" then
		exten = "jpg"
	end

	local crc = util.CRC(url)
	if file.Exists(dir .. "/" .. crc .. "." .. exten, "DATA") then
		mats[url] = TryLoadMat("data/" .. dir .. "/" .. crc .. "." .. exten)

		return mats[url]
	end

	mats[url] = loading_mat

	print("[2D Playermodels] Fetching " .. url .. "...")
	http.Fetch(url, function(data)
		file.Write(dir .. "/" .. crc .. "." .. exten, data)
		file.Write(dir .. "/" .. crc .. "." .. exten .. ".dat", url)
		mats[url] = TryLoadMat("data/" .. dir .. "/" .. crc .. "." .. exten)
		print("[2D Playermodels] Written " .. url .. " to " .. crc .. "." .. exten)
	end, function(error)
		mats[url] = error_mat
		print("[2D Playermodels] Error! Failed to retrieve " .. url)
	end)

	return mats[url]
end

local DepthSortedPlayers = {}

if timer.Exists("2DPlayerModels.UpdateDepthSortedPlayers") then
	timer.Remove("2DPlayerModels.UpdateDepthSortedPlayers")
end

timer.Create("2DPlayerModels.UpdateDepthSortedPlayers", 1, 0, function()
	local tab = {}

	for _, ply in ipairs(player.GetAll()) do
		if ply:GetNWString("2dplayermodel") == "" then continue end

		tab[-GetViewEntity():GetPos():DistToSqr(ply:GetPos())] = ply
	end

	table.Empty(DepthSortedPlayers)
	for _, ply in SortedPairs(tab) do
		DepthSortedPlayers[(#DepthSortedPlayers + 1)] = ply
	end
end)

local death_offset = Vector(0, 0, 30)

hook.Add("PostDrawTranslucentRenderables", "2DPlayerModels.PostDrawTranslucentRenderables", function(depth, sky)
	surface.SetDrawColor(color_white)

	for _, ply in ipairs(DepthSortedPlayers) do
		if ply == LocalPlayer() and not ply:ShouldDrawLocalPlayer() then continue end

		local pm = ply:GetNWString("2dplayermodel")
		if pm == "" then return end

		local mat, w, h = Fetch2DPM(pm), ply:GetNWInt("2dplayermodel_width", 60), ply:GetNWInt("2dplayermodel_height", 80)

		local pos
		if ply:Alive() then
			pos = ply:GetPos()

			if ply:Crouching() then
				h = h * 0.65
			end
		elseif IsValid(ply:GetRagdollEntity()) then
			pos = ply:GetRagdollEntity():GetPos() - death_offset
		else
			continue
		end

		local ang = ply:EyeAngles()
		ang.p = 0
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)
		if not ply:Alive() then
			ang:RotateAroundAxis(ang:Up(), -90)
		end

		cam.Start3D2D(pos + Vector(0, 0, h / 2), ang, 1)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(-(w / 2), -(h / 2), w, h)
		cam.End3D2D()
	end
end)


local color_red = Color(255, 0, 0)
local color_moss = Color(50, 200, 200)

local last_pm_change = 0

hook.Add("OnPlayerChat", "2DPlayerModels.OnPlayerChat", function(ply, txt)
	if string.Trim(txt:lower()) ~= "!2dpm" then return end

	if ply ~= LocalPlayer() then
		return true
	end

	if CurTime() - last_pm_change < 6 then
		chat.AddText(color_red, "Please wait " .. math.ceil(6 - (CurTime() - last_pm_change)) .. " seconds before changing playermodel again.")
		return
	end

	last_pm_change = CurTime()

	Open2DPlayerModelMenu()

	return true
end)

local function AnybodyUsing2DPM()
	for _, ply in pairs(player.GetAll()) do
		if ply ~= LocalPlayer() and ply:GetNWString("2dplayermodel") ~= "" then
			return true
		end
	end

	return false
end

local function CanBrowse2DPMs()
	local images = file.Find(dir .. "/*", "DATA")
	if not images then return false end

	for _, image in ipairs(images) do
		if file.Exists(dir .. "/" .. image .. ".dat", "DATA") then
			return true
		end
	end

	return true
end

net.Receive("2dplayermodel_menu", function(len)
	Open2DPlayerModelMenu()
end)

function Open2DPlayerModelMenu(picked_model)
	local Frame = vgui.Create("DFrame")
	Frame:SetTitle("2D Playermodel")
	Frame:SetSize(400, 230)
	Frame:Center()
	Frame:MakePopup()

	local TopLabel = vgui.Create("DLabel", Frame)
	TopLabel:Dock(TOP)
	TopLabel:DockMargin(4, 4, 4, 0)
	TopLabel:SetText("Enter a URL for your playermodel. Leave blank to return to 3D.")

	local TopLabel2 = vgui.Create("DLabel", Frame)
	TopLabel2:Dock(TOP)
	TopLabel2:DockMargin(4, 0, 4, 4)
	TopLabel2:SetText("Illegal or offensive content will NOT be tolerated!")

	local MidPanel = vgui.Create("DPanel", Frame)
	MidPanel:Dock(FILL)
	MidPanel:DockMargin(4, 4, 4, 4)
	MidPanel:SetPaintBackground(false)

	local TextEntry = vgui.Create("DTextEntry", MidPanel)
	TextEntry:Dock(TOP)
	TextEntry:DockMargin(4, 4, 4, 4)
	if picked_model then
		TextEntry:SetValue(picked_model)
	else
		TextEntry:SetValue(LocalPlayer():GetNWString("2dplayermodel"))
	end

	local HeightSlider = vgui.Create("DNumSlider", MidPanel)
	HeightSlider:Dock(TOP)
	HeightSlider:DockMargin(4, 4, 4, 4)
	HeightSlider:SetText("Height")
	HeightSlider:SetMinMax(50, 90)
	HeightSlider:SetValue(math.Clamp(LocalPlayer():GetNWInt("2dplayermodel_height", 80), 50, 90))
	HeightSlider:SetDefaultValue(80)
	HeightSlider:SetDecimals(0)

	local WidthSlider = vgui.Create("DNumSlider", MidPanel)
	WidthSlider:Dock(TOP)
	WidthSlider:DockMargin(4, 4, 4, 4)
	WidthSlider:SetText("Width")
	WidthSlider:SetMinMax(30, 70)
	WidthSlider:SetValue(math.Clamp(LocalPlayer():GetNWInt("2dplayermodel_width", 60), 30, 70))
	WidthSlider:SetDefaultValue(60)
	WidthSlider:SetDecimals(0)

	local BottomPanel = vgui.Create("DPanel", Frame)
	BottomPanel:Dock(BOTTOM)
	BottomPanel:DockMargin(4, 4, 4, 4)
	BottomPanel:SetPaintBackground(false)

	local StealButton = vgui.Create("DButton", BottomPanel)
	StealButton:Dock(LEFT)
	StealButton:SetText("Steal")
	function StealButton:DoClick()
		if AnybodyUsing2DPM() then
			Open2DPlayerModelStealer()
			Frame:Close()
		else
			chat.AddText(color_moss, "Nobody is using a 2D playermodel right now.")
		end
	end

	local BrowseButton = vgui.Create("DButton", BottomPanel)
	BrowseButton:Dock(LEFT)
	BrowseButton:DockMargin(8, 0, 0, 0)
	BrowseButton:SetText("Browse")
	function BrowseButton:DoClick()
		if CanBrowse2DPMs() then
			Open2DPlayerModelBrowser()
			Frame:Close()
		else
			chat.AddText(color_moss, "You don't have any cached 2D playermodels.")
		end
	end

	local SubmitButton = vgui.Create("DButton", BottomPanel)
	SubmitButton:Dock(FILL)
	SubmitButton:DockMargin(8, 0, 0, 0)
	SubmitButton:SetText("Submit")
	function SubmitButton:DoClick()
		local new_pm = TextEntry:GetValue()
		if new_pm == "" then
			net.Start("2dplayermodel_remove")
			net.SendToServer()
			chat.AddText(color_moss, "Playermodel cleared!")
		else
			net.Start("2dplayermodel_update")
			net.WriteString(TextEntry:GetValue())
			net.WriteUInt(HeightSlider:GetValue(), 8)
			net.WriteUInt(WidthSlider:GetValue(), 8)
			net.SendToServer()
			chat.AddText(color_moss, "Playermodel changed!")
		end
		Frame:Close()
	end
end

local function ReportMenu(url)
	local Frame = vgui.Create("DFrame")
	Frame:SetTitle("Report Image")
	Frame:SetSize(200, 120)
	Frame:Center()
	Frame:MakePopup()

	local TopLabel = vgui.Create("DLabel", Frame)
	TopLabel:Dock(TOP)
	TopLabel:DockMargin(4, 4, 4, 4)
	TopLabel:SetText("What is wrong with this image?")

	local report = false

	local SubmitButton = vgui.Create("DButton", Frame)
	SubmitButton:Dock(BOTTOM)
	SubmitButton:DockMargin(4, 4, 4, 4)
	SubmitButton:SetText("Close")
	function SubmitButton:DoClick()
		if report then
			chat.AddText(color_moss, "Report submitted.")
			net.Start("2dplayermodel_report")
			net.WriteString(url)
			net.WriteInt(report, 5)
			net.SendToServer()
		end
		Frame:Close()
	end

	local Combo = vgui.Create("DComboBox", Frame)
	Combo:Dock(FILL)
	Combo:DockMargin(4, 4, 4, 4)
	Combo:SetValue("Report for...")
	Combo:AddChoice("It's hard to see.", 1)
	Combo:AddChoice("It contains nudity.", 2)
	Combo:AddChoice("It's offensive.", 3)
	Combo:AddChoice("It contains personal information.", 4)
	function Combo:OnSelect(index, value, data)
		report = data
		SubmitButton:SetText("Submit Report")
	end
end

local function Preview2DPM(url)
	local Frame = vgui.Create("DFrame")
	Frame:SetTitle("Playermodel Preview")
	Frame:SetSize(ScrW() / 4, ScrH() / 2)
	Frame:Center()
	Frame:MakePopup()

	local BottomPanel = vgui.Create("DPanel", Frame)
	BottomPanel:Dock(BOTTOM)
	BottomPanel:DockMargin(4, 4, 4, 4)
	BottomPanel:SetPaintBackground(false)

	local ReportButton = vgui.Create("DButton", BottomPanel)
	ReportButton:Dock(LEFT)
	ReportButton:SetText("Report")
	function ReportButton:DoClick()
		ReportMenu(url)
	end

	local CloseButton = vgui.Create("DButton", BottomPanel)
	CloseButton:Dock(FILL)
	CloseButton:DockMargin(8, 0, 0, 0)
	CloseButton:SetText("Close")
	function CloseButton:DoClick()
		Frame:Close()
	end

	local PreviewImage = vgui.Create("DImage", Frame)
	PreviewImage:SetMaterial(Fetch2DPM(url))
	PreviewImage:Dock(FILL)
	PreviewImage:DockMargin(4, 4, 4, 4)
end

function Open2DPlayerModelBrowser()
	local Frame = vgui.Create("DFrame")
	Frame:SetTitle("Browse 2D Playermodels")
	Frame:SetSize(300, 230)
	Frame:Center()
	Frame:MakePopup()

	local BottomPanel = vgui.Create("DPanel", Frame)
	BottomPanel:Dock(BOTTOM)
	BottomPanel:DockMargin(4, 4, 4, 4)
	BottomPanel:SetPaintBackground(false)

	local PreviewButton = vgui.Create("DButton", BottomPanel)
	PreviewButton:Dock(LEFT)
	PreviewButton:SetText("Preview")

	local SubmitButton = vgui.Create("DButton", BottomPanel)
	SubmitButton:Dock(FILL)
	SubmitButton:DockMargin(8, 0, 0, 0)
	SubmitButton:SetText("Use this image")

	local model_list = {}

	local PlayerList = vgui.Create("DListView", Frame)
	PlayerList:Dock(FILL)
	PlayerList:DockMargin(4, 4, 4, 4)
	PlayerList:SetMultiSelect(false)
	PlayerList:AddColumn("Name")
	PlayerList:AddColumn("URL")

	local model_list = {}
	local images = file.Find(dir .. "/*", "DATA")

	for _, image in ipairs(images) do
		if file.Exists(dir .. "/" .. image .. ".dat", "DATA") then
			local url = file.Read(dir .. "/" .. image .. ".dat", "DATA")
			model_list[#model_list + 1] = url
			PlayerList:AddLine(image, url)
		end
	end

	function SubmitButton:DoClick()
		local line = PlayerList:GetSelectedLine()
		local url = model_list[line]
		if url ~= "" then
			Open2DPlayerModelMenu(url)
			Frame:Close()
		end
	end

	function PreviewButton:DoClick()
		local line = PlayerList:GetSelectedLine()
		local url = model_list[line]
		if url ~= "" then
			Preview2DPM(url)
		end
	end

	if #PlayerList:GetLines() == 0 then
		chat.AddText(color_moss, "You don't have any cached 2D playermodels.")
		Open2DPlayerModelMenu()
		Frame:Close()
	end

	PlayerList:SelectFirstItem()
end

function Open2DPlayerModelStealer()
	local Frame = vgui.Create("DFrame")
	Frame:SetTitle("Steal 2D Playermodel")
	Frame:SetSize(300, 230)
	Frame:Center()
	Frame:MakePopup()

	local BottomPanel = vgui.Create("DPanel", Frame)
	BottomPanel:Dock(BOTTOM)
	BottomPanel:DockMargin(4, 4, 4, 4)
	BottomPanel:SetPaintBackground(false)

	local PreviewButton = vgui.Create("DButton", BottomPanel)
	PreviewButton:Dock(LEFT)
	PreviewButton:SetText("Preview")

	local SubmitButton = vgui.Create("DButton", BottomPanel)
	SubmitButton:Dock(FILL)
	SubmitButton:DockMargin(8, 0, 0, 0)
	SubmitButton:SetText("Steal this image")

	local model_list = {}

	local PlayerList = vgui.Create("DListView", Frame)
	PlayerList:Dock(FILL)
	PlayerList:DockMargin(4, 4, 4, 4)
	PlayerList:SetMultiSelect(false)
	PlayerList:AddColumn("Player")
	PlayerList:AddColumn("Image")

	for _, ply in pairs(player.GetAll()) do
		local pm = ply:GetNWString("2dplayermodel")
		if pm ~= "" then
			local mat = Fetch2DPM(pm)
			if mat ~= error_mat and mat ~= loading_mat then
				model_list[#model_list + 1] = pm
				local tab = string.Split(pm, "/")
				local len = #tab
				if len > 0 then
					pm = tab[len]
				end
				PlayerList:AddLine(ply == LocalPlayer() and ply:Nick() .. " (You)" or ply:Nick(), pm)
			end
		end
	end

	function SubmitButton:DoClick()
		local line = PlayerList:GetSelectedLine()
		local url = model_list[line]
		if url ~= "" then
			Open2DPlayerModelMenu(url)
			Frame:Close()
		end
	end

	function PreviewButton:DoClick()
		local line = PlayerList:GetSelectedLine()
		local url = model_list[line]
		if url ~= "" then
			Preview2DPM(url)
		end
	end

	if #PlayerList:GetLines() == 0 then
		chat.AddText(color_moss, "Nobody is using a 2D playermodel right now.")
		Open2DPlayerModelMenu()
		Frame:Close()
	end

	PlayerList:SelectFirstItem()
end
