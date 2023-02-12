
local crit_time = CreateConVar("crit_show_time", 2, FCVAR_ARCHIVE, "How long critical hit text is displayed.", 0)

local CritSound = Sound("player/crit_hit.wav")
local ReceieveSound = Sound("player/crit_received1.wav")

surface.CreateFont("RandomCrits.Overhead", {
	font = "Comic Sans MS",
	size = 32,
	weight = 1000,
	antialias = true,
})

surface.CreateFont("RandomCrits.Boosted", {
	font = "Comic Sans MS",
	size = ScreenScale(20),
	weight = 1000,
	antialias = true,
})

local crits = {}

net.Receive("RandomCrits.SendToClient", function(len)
	local minicrit = net.ReadBool()
	local victim = net.ReadEntity()
	local atk = net.ReadEntity()
	if victim:IsPlayer() and victim == LocalPlayer() then
		if minicrit then
		else
			surface.PlaySound("player/crit_received" .. math.random(3) .. ".wav")
		end
	elseif atk == LocalPlayer() then
		surface.PlaySound(CritSound)
	else
		ply:EmitSound(CritSound, 75, math.random(80, 120))
	end
	local pos = isfunction(victim.EyePos) and victim:EyePos() or victim:GetPos()
	crits[#crits + 1] = {CurTime(), pos, minicrit}
end)

local offset = Vector(0, 0, 25)

hook.Add("PostDrawOpaqueRenderables", "RandomCrits.PostDrawOpaqueRenderables", function()
	for _, crit in ipairs(crits) do
		local frac = (CurTime() - crit[1]) / crit_time:GetFloat()

		local ang = LocalPlayer():EyeAngles()
		local pos = ply:EyePos() + offset + ang:Up() + Vector(0, 0, frac * 12)

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
			if crit[3] then
				draw.DrawText("MINI\nCRIT!", "RandomCrits.Overhead", 2, 2, Color(255 * (1 - frac), 255, 0, 255 * (1 - frac)), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("CRITICAL\nHIT!", "RandomCrits.Overhead", 2, 2, Color(frac * 255, 255 * (1 - frac), 0, 255 * (1 - frac)), TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end)

hook.Add("HUDPaint", "RandomCrits.HUDPaint", function()
	if not LocalPlayer():GetNWBool("crit_boosted") then return end
	local frac = math.sin(CurTime() * 2)
	draw.DrawText("CRIT BOOSTED", "RandomCrits.Boosted", ScrW() / 2, (ScrH() / 26) + (frac * 5), Color(frac * 255, 255 - (frac * 255), 0, 255), TEXT_ALIGN_CENTER)
end)
