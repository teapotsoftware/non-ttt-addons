-- The AstolfAWP :3
-- by Nick B (02/28/2022)

if SERVER then
	resource.AddFile("models/weapons/w_fmby_awp.mdl")
	resource.AddFile("models/weapons/nickb/c_femboy_awp.mdl")
	resource.AddFile("materials/models/weapons/v_models/fmby_awp/v_awp.vmt")
	resource.AddFile("materials/models/weapons/v_models/fmby_awp/v_awp_scope.vmt")
	resource.AddFile("materials/models/weapons/w_models/fmby_awp/w_snip_awp.vmt")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_01.wav")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_02.wav")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_03.wav")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_04.wav")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_05.wav")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_bolt.wav")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_clipin.wav")
	resource.AddFile("sound/nickb/femboy_awp/femboy_awp_clipout.wav")
else
	language.Add("femboy_awp_ammo", "Femboy Cummies")
end

game.AddAmmoType({
	name = "femboy_awp",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE_AND_WHIZ,
})

sound.Add({
	name = "Femboy_AWP.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {
		"nickb/femboy_awp/femboy_awp_01.wav",
		"nickb/femboy_awp/femboy_awp_02.wav",
		"nickb/femboy_awp/femboy_awp_03.wav",
		"nickb/femboy_awp/femboy_awp_04.wav"
	}
})

sound.Add({
	name = "Femboy_AWP.ClipIn",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = {95, 105},
	sound = "nickb/femboy_awp/femboy_awp_clipin.wav"
})

sound.Add({
	name = "Femboy_AWP.ClipOut",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = {95, 105},
	sound = "nickb/femboy_awp/femboy_awp_clipout.wav"
})

sound.Add({
	name = "Femboy_AWP.Bolt",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = {95, 105},
	sound = "nickb/femboy_awp/femboy_awp_bolt.wav"
})
