
-- Doors

sound.Add({
	name = "Door.Locked",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 50,
	pitch = {95, 110},
	sound = "buttons/weapon_cant_buy.wav"
})

sound.Add({
	name = "Door.Open",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 50,
	pitch = {95, 110},
	sound = "buttons/blip2.wav"
})

sound.Add({
	name = "Door.Auth",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 50,
	pitch = {95, 110},
	sound = "buttons/bell1.wav"
})

-- Blocks

sound.Add({
	name = "Block.Place",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 60,
	pitch = {95, 110},
	sound = {"physics/concrete/concrete_impact_hard1.wav", "physics/concrete/concrete_impact_hard2.wav", "physics/concrete/concrete_impact_hard3.wav"}
})

sound.Add({
	name = "Block.Break",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 60,
	pitch = {95, 110},
	sound = {"physics/concrete/concrete_break2.wav", "physics/concrete/concrete_break3.wav"}
})
