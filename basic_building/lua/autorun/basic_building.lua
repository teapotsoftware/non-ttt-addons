
AddCSLuaFile("building/sh_levels.lua")
AddCSLuaFile("building/sh_meta.lua")
AddCSLuaFile("building/sh_sounds.lua")

include("building/sh_levels.lua")
include("building/sh_meta.lua")
include("building/sh_sounds.lua")

if SERVER then
	include("building/sv_gather.lua")
end
