
if SERVER then
	AddCSLuaFile("battleroyale/sh_funcs.lua")
	AddCSLuaFile("battleroyale/sh_meta.lua")

	include("battleroyale/sv_debug.lua")
	include("battleroyale/sv_endgame.lua")
	include("battleroyale/sv_wepinv.lua")
end

include("battleroyale/sh_funcs.lua")
include("battleroyale/sh_meta.lua")
