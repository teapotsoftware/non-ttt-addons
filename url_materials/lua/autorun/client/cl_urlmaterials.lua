
local dir = "downloaded_assets"
file.CreateDir(dir)

local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local crc = util.CRC
local exten = string.GetExtensionFromFilename

local error_mat = Material("icon16/cancel.png")
local loading_mat = Material("icon16/hourglass.png")
local mats = {}

local function TryLoadMat(name)
	local mat = Material(name)
	if mat:IsError() then
		return error_mat
	end
	return mat
end

function MaterialURL(url, onload)
	if not url or url == "" then return error_mat end

	if mats[url] then
		if onload then
			onload(mats[url])
		end
		return mats[url]
	end

	local crc = util.CRC(url)
	local exten = string.GetExtensionFromFilename(url)
	if not exten then return error_mat end

	if exten == "jpeg" then
		exten = "jpg"
	end

	if file.Exists(dir .. "/" .. crc .. "." .. exten, "DATA") then
		mats[url] = TryLoadMat("data/" .. dir .. "/" .. crc .. "." .. exten)
		if onload then
			onload(mats[url])
		end
		return mats[url]
	end

	mats[url] = loading_mat

	print("[MaterialURL] Fetching " .. url .. "...")
	http.Fetch(url, function(data)
		file.Write(dir .. "/" .. crc .. "." .. exten, data)
		mats[url] = TryLoadMat("data/" .. dir .. "/" .. crc .. "." .. exten)
		print("[MaterialURL] Wrote " .. url .. " to " .. crc .. "." .. exten)
		if onload then
			onload(mats[url])
		end
	end, function(error)
		mats[url] = error_mat
		print("[MaterialURL] Error! Failed to retrieve " .. url)
	end)

	return mats[url]
end

function TextureURL(url)
	if not url then return "error.png" end

	local path = dir .. "/" .. crc(url) .. "." .. exten(url)

	if not exists(path, "DATA") then
		fetch(url, function(data)
			write(path, data)
		end)
	end

	return "data/" .. path
end
