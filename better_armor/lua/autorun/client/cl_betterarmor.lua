
local armor_visible = CreateConVar("armor_show", 1, FCVAR_ARCHIVE, "Should armor be visible on players?", 0, 1)

local armor = {
	--["helmet"] = { type = "Model", model = "models/hunter/misc/shell2x2a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4, 0, 0), ang = Angle(-90, 7.363, -15.195), size = Vector(0.09, 0.111, 0.09), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/indenttiles_1-2", skin = 0, bodygroup = {} },
	--["plate_back"] = { type = "Model", model = "models/hunter/plates/plate2x3.mdl", bone = "ValveBiped.Bip01_Spine1", rel = "", pos = Vector(2.53, 4.281, 0), ang = Angle(89.096, 98.18, 0), size = Vector(0.143, 0.143, 0.143), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/indenttiles_1-2", skin = 0, bodygroup = {} },
	["leg_right"] = { type = "Model", model = "models/props_c17/playground_swingset_seat01a.mdl", bone = "ValveBiped.Bip01_R_Thigh", rel = "", pos = Vector(9.833, 3.114, -0.255), ang = Angle(1.118, 2.565, 108.166), size = Vector(0.46, 0.56, 0.46), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/indenttiles_1-2", skin = 0, bodygroup = {} },
	["leg_left"] = { type = "Model", model = "models/props_c17/playground_swingset_seat01a.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(9.833, 3.114, -0.255), ang = Angle(1.118, 2.565, 80.15), size = Vector(0.46, 0.56, 0.46), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/indenttiles_1-2", skin = 0, bodygroup = {} },
	["plate"] = { type = "Model", model = "models/hunter/plates/plate2x3.mdl", bone = "ValveBiped.Bip01_Spine1", rel = "", pos = Vector(4, -9.16 - 1.2, 0), ang = Angle(90, 92.342, 0), size = Vector(0.12, 0.11, 0.143), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/indenttiles_1-2", skin = 0, bodygroup = {} },
	["vest"] = { type = "Model", model = "models/props_vehicles/tire001b_truck.mdl", bone = "ValveBiped.Bip01_Spine1", rel = "", pos = Vector(2.463, -0.402 - 1.2, 0), ang = Angle(0, 7.36, 0), size = Vector(1.335, 0.263, 0.312), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["helmet"] = { type = "Model", model = "models/props_interiors/pot02a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.927, -2.175, 5.348), ang = Angle(-27.164, 105.624, -99.923), size = Vector(1.006, 1.006, 1.006), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

}

local show_cmds = {}

local armor_models = {}
for k, v in pairs(armor) do
	show_cmds[k] = CreateConVar("armor_show_" .. k, 1, FCVAR_ARCHIVE, "Should armor " .. k .. " be visible on players?", 0, 1)
	armor_models[k] = ClientsideModel(v.model)
	armor_models[k]:SetNoDraw(true)
	local mat = Matrix()
	mat:Scale(v.size)
	armor_models[k]:EnableMatrix("RenderMultiply", mat)
	armor_models[k]:SetMaterial(v.material)
end

hook.Add("PostPlayerDraw", "BetterArmor.PostPlayerDraw", function(ply)
	if armor_visible:GetBool() and IsValid(ply) and ply:Armor() > 0 and ply:Alive() then
		for k, v in pairs(armor) do
			if not show_cmds[k]:GetBool() then continue end

			local bone = ply:LookupBone(v.bone)
			if not bone then continue end

			local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			local m = ply:GetBoneMatrix(bone)
			if m then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.ang.y)
			ang:RotateAroundAxis(ang:Right(), v.ang.p)
			ang:RotateAroundAxis(ang:Forward(), v.ang.r)

			local model = armor_models[k]
			model:SetPos(pos)
			model:SetAngles(ang)
			model:SetRenderOrigin(pos)
			model:SetRenderAngles(ang)
			model:SetupBones()
			model:DrawModel()
			model:SetRenderOrigin()
			model:SetRenderAngles()
		end
	end
end)
