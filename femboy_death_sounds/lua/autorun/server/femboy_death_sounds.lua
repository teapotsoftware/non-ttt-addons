
local deathsounds = {
	Sound("nickb/femboy/femboy_death_01.wav"),
	Sound("nickb/femboy/femboy_death_02.wav"),
	Sound("nickb/femboy/femboy_death_03.wav"),
	Sound("nickb/femboy/femboy_death_04.wav"),
	Sound("nickb/femboy/femboy_death_05.wav"),
	Sound("nickb/femboy/femboy_death_06.wav"),
	Sound("nickb/femboy/femboy_death_07.wav"),
	Sound("nickb/femboy/femboy_death_08.wav"),
	Sound("nickb/femboy/femboy_death_09.wav"),
	Sound("nickb/femboy/femboy_death_10.wav"),
	Sound("nickb/femboy/femboy_death_11.wav"),
	Sound("nickb/femboy/femboy_death_12.wav"),
	Sound("nickb/femboy/femboy_death_13.wav"),
	Sound("nickb/femboy/femboy_death_14.wav"),
	Sound("nickb/femboy/femboy_death_15.wav"),
	Sound("nickb/femboy/femboy_death_16.wav"),
	Sound("nickb/femboy/femboy_death_17.wav"),
	Sound("nickb/femboy/femboy_death_18.wav")
}

for _, v in ipairs(deathsounds) do
	resource.AddFile("sound/" .. v)
end

hook.Add("DoPlayerDeath", "FemboyDeathSounds.PostPlayerDeath", function(ply, atk, dmg)
	ply:EmitSound(deathsounds[math.random(#deathsounds)])
end)
