
local msg = CreateConVar("death_message", "Dead", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Message shown on death.")

if SERVER then return end

hook.Add("CalcView", "FirstPersonDeath", function(ply, pos, ang, fov, nearz, farz)
	ply = LocalPlayer()
	if ply:Alive() then ply.FadingOutOfConsciousness = nil return end
	if ply.FadingOutOfConsciousness == nil then
		ply.FadingOutOfConsciousness = CurTime()
	end
	local rag = ply:GetRagdollEntity()
	if not IsValid(rag) then return end
	local eyeattach = rag:LookupAttachment("eyes")
	if not eyeattach then return end
	local eyes = rag:GetAttachment(eyeattach)
	if not eyes then return end
	return {origin = eyes.Pos, angles = eyes.Ang, fov = fov}
end)

surface.CreateFont("YouDied", {
	font = "Verdana",
	size = ScreenScale(80),
	weight = 5000,
	antialias = true,
})

hook.Add("HUDPaint", "FadeOutOfConsciousness", function()
	if LocalPlayer():Alive() then return end

	local frac = math.min(CurTime() - (LocalPlayer().FadingOutOfConsciousness or 0), 2) / 2
	local fade_in = frac * 255
	draw.SimpleTextOutlined(msg:GetString(), "YouDied", ScrW() / 2, Lerp(frac * 6, 0, ScrH() / 3), Color(255, 255, 255, fade_in), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ScreenScale(2), Color(0, 0, 0, fade_in))
end)
