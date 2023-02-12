AddCSLuaFile()

DUMPSTER_DIVING_ENTITIES = {
	["dd_dumpster"] = {PrintName = "Dumpster", Model = "models/props_junk/TrashDumpster01a.mdl", Size = 3},
	["dd_trash_can"] = {PrintName = "Trash Can", Model = "models/props_trainstation/trashcan_indoor001a.mdl", Size = 4},
	["dd_recycling_bin"] = {PrintName = "Recycling Bin", Model = "models/props_junk/TrashBin01a.mdl", Size = 3},
	["dd_small_box"] = {PrintName = "Small Box", Model = "models/props_junk/cardboard_box004a.mdl", Size = 1},
	["dd_large_box"] = {PrintName = "Large Box", Model = "models/props_junk/cardboard_box003a.mdl", Size = 1},
}

print("[DD] Registering dumpster diving entities...")

for k, v in SortedPairs(DUMPSTER_DIVING_ENTITIES) do
	v.Base = "dumpster_diving_base"
	v.Spawnable = true
	v.Category = "Dumpster Diving"
	scripted_ents.Register(v, k)
	print("[DD] Registered entity: " .. k)
end

print("[DD] Dumpster diving entities registered!")