
local cv_salary = CreateConVar("money_salary", 45, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Player salary.", 0)
local cv_paytime = CreateConVar("money_salary_time", 600, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Time between paydays.", 0)
local cv_savetime = CreateConVar("money_save_time", 30, FCVAR_ARCHIVE + FCVAR_REPLICATED, "How often money is saved to disk.", 0)
local cv_deathdrop = CreateConVar("money_death_drop", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "How much money is dropped on death.", 0)
local cv_killfine = CreateConVar("money_kill_penalty", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Fine for killing another player.", 0)
local cv_startmoney = CreateConVar("money_default", 500, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Starting money.", 0)
local cv_defaultprice = CreateConVar("money_price_default", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Default cost of entities from the spawnmenu.", 0)

if DarkRP and not DarkRP.sandboxMoney then
	return
else
	DarkRP = {sandboxMoney = true}
end

DarkRP.formatMoney = function(amt)
	return "$" .. string.Comma(amt)
end

local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")

function ENTITY:isMoneyBag()
	return self.IsSpawnedMoney
end
ENTITY.IsMoneyBag = ENTITY.isMoneyBag

function PLAYER:canAfford(amount)
	return self:getDarkRPVar("money") >= amount
end
PLAYER.CanAfford = PLAYER.canAfford

function PLAYER:getDarkRPVar(var)
	if var == "money" then
		return self:GetNWInt("money")
	end
	if var == "salary" then
		return cv_salary:GetInt()
	end
end
PLAYER.GetDarkRPVar = PLAYER.getDarkRPVar

if SERVER then
	function PLAYER:addMoney(amount)
		self:SetNWInt("money", self:getDarkRPVar("money") + amount)
	end
	PLAYER.AddMoney = PLAYER.addMoney

	function PLAYER:payDay()
		local salary = cv_salary:GetInt()
		self:addMoney(salary)
		self:ChatPrint("Payday! You were paid your " .. DarkRP.formatMoney(salary) .. " salary.")
	end
	PLAYER.PayDay = PLAYER.payDay

	DarkRP.createMoneyBag = function(pos, amount)
		local money = ents.Create("spawned_money")
		money:SetPos(pos)
		money:Spawn()
		money:Setamount(amount)

		return money
	end

	DarkRP.payPlayer = function(sender, receiver, amount)
		sender:addMoney(-amount)
		receiver:addMoney(amount)

		local money = DarkRP.formatMoney(amount)
		sender:ChatPrint("You paid " .. money .. " to " .. receiver:Nick() .. ".")
		receiver:ChatPrint("You were given " .. money .. " by " .. sender:Nick() .. ".")
	end

	local last_payday = 0
	local last_save = 0

	if not file.Exists("sandbox_money/prices", "DATA") then
		file.CreateDir("sandbox_money/prices")
		file.Write("sandbox_money/prices/money_printer.txt", 1000)
		file.Write("sandbox_money/readme.txt", [[
Hey there, admin!

This folder stores everybody's sandbox money.
To edit people's money, it's recommended to use /setmoney in-game.
If you really want to edit these files, keep in mind that they are overridden by in-game values and only load when a player connects to your server.]])
		file.Write("sandbox_money/prices/readme.txt", [[
Hey there, admin!

This folder stores the prices of entities from the spawnmenu.
You can edit these files to change the prices as you wish, but keep in mind that you can also use /setprice in-game.]])
	end

	hook.Add("Think", "SandboxMoney.Think", function()
		if CurTime() - last_save > cv_savetime:GetInt() then
			last_save = CurTime()
			for _, ply in ipairs(player.GetAll()) do
				local sid
				if game.SinglePlayer() then
					sid = "singleplayer"
				else
					sid = ply:SteamID64()
				end
				file.Write("sandbox_money/" .. sid .. ".txt", ply:getDarkRPVar("money"))
			end
		end
		if CurTime() - last_payday > cv_paytime:GetInt() then
			last_payday = CurTime()
			for _, ply in ipairs(player.GetAll()) do
				ply:payDay()
			end
		end
	end)

	hook.Add("PlayerAuthed", "SandboxMoney.PlayerAuthed", function(ply, steamid)
		local sid
		if game.SinglePlayer() then
			sid = "singleplayer"
		else
			sid = ply:SteamID64()
		end
		local save = "sandbox_money/" .. sid .. ".txt"
		if file.Exists(save, "DATA") then
			ply:SetNWInt("money", tonumber(file.Read(save)) or 0)
		else
			ply:SetNWInt("money", cv_startmoney:GetInt())
		end
	end)

	hook.Add("PlayerDeath", "SandboxMoney.PlayerDeath", function(victim, inf, atk)
		if IsValid(atk) and atk:IsPlayer() and atk ~= victim then
			victim.BountyTable = {}
			local bounty = victim:GetNWInt("bounty")
			victim:SetNWInt("bounty", 0)

			if bounty > 0 then
				atk:addMoney(bounty)
				PrintMessage(HUD_PRINTTALK, "The " .. DarkRP.formatMoney(bounty) .. " bounty on " .. victim:Nick() .. " has been claimed by " .. atk:Nick() .. ".")
			elseif cv_killfine:GetInt() > 0 then
				local fine = cv_killfine:GetInt()
				local money = atk:getDarkRPVar("money")

				if money > 0 then
					fine = math.min(fine, money)
					atk:addMoney(-fine)
					atk:ChatPrint("Bad sport! You have been fined " .. DarkRP.formatMoney(fine) .. " for killing " .. victim:Nick() .. ".")
				end
			end
		end

		local drop_amt = math.min(cv_deathdrop:GetInt(), victim:getDarkRPVar("money"))
		if drop_amt > 0 then
			victim:addMoney(-drop_amt)
			DarkRP.createMoneyBag(victim:GetPos() + Vector(0, 0, 12), drop_amt)
			victim:ChatPrint("You dropped " .. DarkRP.formatMoney(drop_amt) .. " from dying.")
		end
	end)

	hook.Add("PlayerDisconnected", "SandboxMoney.PlayerDisconnected", function(victim)
		local sid
		if game.SinglePlayer() then
			sid = "singleplayer"
		else
			sid = victim:SteamID64()
		end
		file.Write("sandbox_money/" .. sid .. ".txt", victim:getDarkRPVar("money"))
		if istable(victim.BountyTable) then
			for ply, amt in pairs(victim.BountyTable) do
				if IsValid(ply) then
					ply:addMoney(amt)
					ply:ChatPrint("You have been refunded your " .. DarkRP.formatMoney(amt) .. " bounty on " .. victim:Nick() .. ".")
				end
			end
		end
	end)

	local function InvalidAmount(ply, amount)
		if not amount or (amount < 1) then
			ply:ChatPrint("Invalid amount.")
			return true
		end

		if not ply:canAfford(amount) then
			ply:ChatPrint("You don't have that much money!")
			return true
		end

		return false
	end

	local function FindPlayer(name)
		name = string.lower(name)
		local found = false
		for _, ply in ipairs(player.GetAll()) do
			if string.find(string.lower(ply:Nick()), name, 1, true) ~= nil then
				if found then return -1 end
				found = ply
			end
		end
		return found
	end

	local commands = {
		["/bounty"] = function(ply, args)
			if not args[1] or not args[2] then
				ply:ChatPrint("Usage: /bounty <player> <amount>\nSet a bounty on a player.")
				return
			end

			local target = FindPlayer(args[1])
			if not target then
				ply:ChatPrint("Invalid target.")
				return
			elseif target == -1 then
				ply:ChatPrint("Multiple targets found.")
				return
			end

			local amount = tonumber(args[2])
			if InvalidAmount(ply, amount) then
				return
			end

			local bounty = target:GetNWInt("bounty")
			local fine = cv_killfine:GetInt()
			if bounty + amount < fine then
				ply:ChatPrint("Bounties cannot be lower than " .. DarkRP.formatMoney(fine) .. ".")
				return
			end

			ply:addMoney(-amount)
			target:SetNWInt("bounty", bounty + amount)
			PrintMessage(HUD_PRINTTALK, ply:Nick() .. " has placed a " .. DarkRP.formatMoney(amount) .. " bounty on " .. target:Nick() .. ".")

			if not target.BountyTable then
				target.BountyTable = {ply = amount}
			elseif target.BountyTable[ply] then
				target.BountyTable[ply] = target.BountyTable[ply] + amount
			else
				target.BountyTable[ply] = amount
			end
		end,
		["/balance"] = function(ply, args)
			ply:ChatPrint("You have " .. DarkRP.formatMoney(ply:getDarkRPVar("money")) .. ".")
		end,
		["/bal"] = "/balance",
		["/dropmoney"] = function(ply, args)
			if not args[1] then
				ply:ChatPrint("Usage: /dropmoney <amount>\nDrop money on the floor.")
				return
			end

			local amount = tonumber(args[1])
			if InvalidAmount(ply, amount) then
				return
			end

			local pos = ply:EyePos() + (ply:GetAimVector() * 30)
			if not util.IsInWorld(pos) then
				ply:ChatPrint("You can't drop money here.")
				return
			end

			ply:addMoney(-amount)
			DarkRP.createMoneyBag(pos, amount)

			ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
		end,
		["/moneydrop"] = "/dropmoney",
		["/pay"] = function(ply, args)
			if not args[1] or not args[2] then
				ply:ChatPrint("Usage: /pay <player> <amount>\nGive money to a specific player.")
				return
			end

			local target = FindPlayer(args[1])
			if not target then
				ply:ChatPrint("Invalid target.")
				return
			elseif target == -1 then
				ply:ChatPrint("Multiple targets found.")
				return
			end

			if target == ply then
				ply:ChatPrint("You can't pay yourself!")
				return
			end

			local amount = tonumber(args[1])
			if InvalidAmount(ply, amount) then
				return
			end

			DarkRP.payPlayer(ply, target, amount)
		end,
		["/check"] = function(ply, args)
			if not args[1] or not args[2] then
				ply:ChatPrint("Usage: /check <player> <amount>\nWrite a check for a specific player.")
				return
			end

			local target = FindPlayer(args[1])
			if not target then
				ply:ChatPrint("Invalid target.")
				return
			elseif target == -1 then
				ply:ChatPrint("Multiple targets found.")
				return
			end

			local amount = tonumber(args[2])
			if InvalidAmount(ply, amount) then
				return
			end

			local pos = ply:EyePos() + (ply:GetAimVector() * 30)
			if not util.IsInWorld(pos) then
				ply:ChatPrint("You can't write a check here.")
				return
			end

			ply:addMoney(-amount)

			local check = ents.Create("darkrp_cheque")
			check:SetPos(pos)
			check:SetWriter(ply)
			check:SetRecipient(target)
			check:Setamount(amount)
			check:Spawn()

			ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
		end,
		["/cheque"] = "/check",
		["/give"] = function(ply, args)
			if not args[1] then
				ply:ChatPrint("Usage: /give <amount>\nGive money to the player you're looking at.")
				return
			end

			local target = ply:GetEyeTrace().Entity
			if not IsValid(target) or not target:IsPlayer() then
				ply:ChatPrint("Invalid target.")
				return
			end

			local amount = tonumber(args[1])
			if InvalidAmount(ply, amount) then
				return
			end

			DarkRP.payPlayer(ply, target, amount)
		end,
		["/setmoney"] = function(ply, args)
			if not ply:IsAdmin() then
				ply:ChatPrint("You do not have access to that command.")
				return
			end

			if not args[1] or not args[2] then
				ply:ChatPrint("Usage: /setmoney <player> <amount>\nSet a player's money. (Admin only)")
				return
			end

			local target = FindPlayer(args[1])
			if args[1] == "*" then
				target = player.GetAll()
			elseif not target then
				ply:ChatPrint("Invalid target.")
				return
			elseif target == -1 then
				ply:ChatPrint("Multiple targets found.")
				return
			end

			local amount = tonumber(args[2])
			if not amount or amount < 0 then
				ply:ChatPrint("Invalid amount.")
				return
			end

			for _, p in ipairs(istable(target) and target or {target}) do
				p:SetNWInt("money", amount)
				p:ChatPrint("Your money has been set to " .. DarkRP.formatMoney(amount) .. ".")
			end
		end,
		["/setprice"] = function(ply, args)
			if not ply:IsAdmin() then
				ply:ChatPrint("You do not have access to that command.")
				return
			end

			if not args[1] or args[1] == "" then
				ply:ChatPrint("Usage: /setprice <entity> [price]\nSet the price of an entity. (Admin only)\nEnter a blank price to reset to default.")
				return
			end

			if not args[2] then
				file.Delete("sandbox_money/prices/" .. args[1] .. ".txt")
				ply:ChatPrint("Price of " .. args[1] .. " reset to default.")
				return
			end

			local amount = tonumber(args[2])
			if not amount or amount < 0 then
				ply:ChatPrint("Invalid price.")
				return
			end

			file.Write("sandbox_money/prices/" .. args[1] .. ".txt", amount)
			ply:ChatPrint("Price of " .. args[1] .. " has been set to " .. DarkRP.formatMoney(amount) .. ".")
		end
	}

	commands["/moneyhelp"] = function(ply, args)
		local help = "Money commands:\n"
		for k, v in SortedPairs(commands) do
			help = help .. k .. "    "
		end
		ply:ChatPrint(help)
	end

	hook.Add("PlayerSay", "SandboxMoney.PlayerSay", function(ply, text)
		local args = string.Split(string.lower(text), " ")
		local cmd = commands[args[1]]
		if cmd then
			if isstring(cmd) then
				cmd = commands[cmd]
			end
			table.remove(args, 1)
			cmd(ply, args)
			return ""
		end
	end)

	local function TrySpawnEntity(ply, class)
		local fil = "sandbox_money/prices/" .. class .. ".txt"
		local price = 0
		if file.Exists(fil, "DATA") then
			price = tonumber(file.Read(fil, "DATA"))
		else
			price = cv_defaultprice:GetInt()
		end
		if price > 0 then
			if ply:canAfford(price) then
				return true
			else
				ply:ChatPrint("You can't afford that!")
				return false
			end
		end
	end

	local function AfterSpawnEntity(ply, ent)
		local fil = "sandbox_money/prices/" .. ent:GetClass() .. ".txt"
		local price = 0
		if file.Exists(fil, "DATA") then
			price = tonumber(file.Read(fil, "DATA"))
		else
			price = cv_defaultprice:GetInt()
		end
		price = math.min(price, ply:getDarkRPVar("money"))
		if price > 0 then
			ply:addMoney(-price)
			ply:ChatPrint("You bought a " .. ent.PrintName .. " for " .. DarkRP.formatMoney(price) .. ".")
		end
	end

	for _, v in ipairs({"SENT", "NPC"}) do
		hook.Add("PlayerSpawn" .. v, "SandboxMoney.PlayerSpawn" .. v, TrySpawnEntity)
		hook.Add("PlayerSpawned" .. v, "SandboxMoney.PlayerSpawned" .. v, AfterSpawnEntity)
	end

	-- special cases
	-- hook.Add("PlayerGiveSWEP", "SandboxMoney.PlayerGiveSWEP", function(ply, wep, ent)
	-- 	if TrySpawnEntity(ply, wep) then
	-- 		AfterSpawnEntity(ply, ent)
	-- 		return true
	-- 	else
	-- 		return false
	-- 	end
	-- end)

	hook.Add("PlayerSpawnVehicle", "SandboxMoney.PlayerSpawnVehicle", function(ply, mdl, name)
		return TrySpawnEntity(ply, name)
	end)
	hook.Add("PlayerSpawnedVehicle", "SandboxMoney.PlayerSpawnedVehicle", AfterSpawnEntity)
else
	surface.CreateFont("SandboxMoney.HUD", {
		font = "Arial",
		size = ScreenScale(10),
		weight = 800
	})

	local function BountyColor()
		return Color(200 + (20 * math.sin(CurTime() * 3)), 0, 0)
	end

	local function DiffColor(diff, last_diff)
		local clr = Color(0, 0, 0, math.Clamp(255 - ((CurTime() - last_diff) * 400), 0, 255))
		if diff > 0 then
			clr.g = 255
		else
			clr.r = 255
		end
		return clr
	end

	local money_old, diff, last_diff = 0, 0, 0
	hook.Add("HUDPaint", "SandboxMoney.HUDPaint", function()
		local ply = LocalPlayer()
		local money = ply:getDarkRPVar("money")
		local bounty = ply:GetNWInt("bounty")
		local padding = ScrW() / 200

		local w, h = draw.SimpleText(DarkRP.formatMoney(money), "SandboxMoney.HUD", padding, padding - 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local new_diff = money - money_old

		if CurTime() - last_diff < 1 then
			diff = diff + new_diff
		else
			diff = new_diff
		end

		if new_diff ~= 0 then
			last_diff = CurTime()
		end

		draw.SimpleText((diff > 0 and "+" or "-") .. DarkRP.formatMoney(math.abs(diff)), "SandboxMoney.HUD", padding, h + padding + ((CurTime() - last_diff) * 20) - 10, DiffColor(diff, last_diff), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		if bounty > 0 then
			draw.SimpleText(DarkRP.formatMoney(bounty) .. " Bounty", "SandboxMoney.HUD", (padding * 2) + w, padding - 5, BountyColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		money_old = money
	end)

	local shadow_1 = Color(0, 0, 0, 120)
	local shadow_2 = Color(0, 0, 0, 50)

	hook.Add("HUDDrawTargetID", "SandboxMoney.HUDDrawTargetID", function()
		local tr = LocalPlayer():GetEyeTrace()
		if not tr.Hit or not tr.HitNonWorld then return end

		local ply = tr.Entity
		if not ply:IsPlayer() then return end

		local bounty = ply:GetNWInt("bounty")
		if bounty < 1 then return end

		local text = "Bounty: " .. DarkRP.formatMoney(bounty)
		local font = "TargetID"

		surface.SetFont(font)
		local w, h = surface.GetTextSize(text)

		local MouseX, MouseY = gui.MousePos()

		if MouseX == 0 and MouseY == 0 then
			MouseX = ScrW() / 2
			MouseY = ScrH() / 2
		end

		local x = MouseX
		local y = MouseY

		x = x - w / 2
		y = y + 35 + (2 * h)

		draw.SimpleText(text, font, x + 1, y + 1, shadow_1)
		draw.SimpleText(text, font, x + 2, y + 2, shadow_2)
		draw.SimpleText(text, font, x, y, BountyColor())
	end)

	hook.Add("AddToolMenuTabs", "SandboxMoney.AddToolMenuTabs", function()
		spawnmenu.AddToolTab("Money", "Money", "icon16/money.png")
	end)

	hook.Add("AddToolMenuCategories", "SandboxMoney.AddToolMenuCategories", function()
		spawnmenu.AddToolCategory("Money", "Money", "Money")
	end)

	hook.Add("PopulateToolMenu", "SandboxMoney.PopulateToolMenu", function()
		spawnmenu.AddToolMenuOption("Money", "Money", "MoneyCommands", "Commands", "", "", function(panel)
			panel:ClearControls()
			local text = panel:TextEntry("Target Player", "")
			local slider = panel:NumSlider("Money Amount", "", 1, 3000, 0)
			slider:SetValue(1)
			panel:Button("Drop amount", "").DoClick = function()
				LocalPlayer():ConCommand("say /dropmoney " .. math.Round(slider:GetValue()))
			end
			panel:Button("Pay amount to target", "").DoClick = function()
				LocalPlayer():ConCommand("say /pay " .. text:GetValue() .. " " ..  math.Round(slider:GetValue()))
			end
			panel:Button("Set bounty on target", "").DoClick = function()
				LocalPlayer():ConCommand("say /bounty " .. text:GetValue() .. " " ..  math.Round(slider:GetValue()))
			end
			panel:Button("Write check to target", "").DoClick = function()
				LocalPlayer():ConCommand("say /check " .. text:GetValue() .. " " ..  math.Round(slider:GetValue()))
			end
			panel:Button("Set target's money (Admin only)", "").DoClick = function()
				LocalPlayer():ConCommand("say /setmoney " .. text:GetValue() .. " " ..  math.Round(slider:GetValue()))
			end
			panel:Button("Set entity price (Admin only)", "").DoClick = function()
				LocalPlayer():ConCommand("say /setprice " .. text:GetValue() .. " " ..  math.Round(slider:GetValue()))
			end
		end)

		spawnmenu.AddToolMenuOption("Money", "Money", "MoneyAdmin", "Settings (Admin)", "", "", function(panel)
			panel:ClearControls()
			panel:NumSlider("Starting money", "money_default", 0, 20000, 0)
			panel:NumSlider("Drop on death", "money_death_drop", 0, 200, 0)
			panel:NumSlider("Kill penalty", "money_kill_penalty", 0, 200, 0)
			panel:NumSlider("Salary", "money_salary", 0, 500, 0)
			panel:NumSlider("Salary time", "money_salary_time", 60, 1000, 0)
			panel:NumSlider("Default entity price", "money_price_default", 1, 1000, 0)
			panel:NumSlider("Save interval", "money_save_time", 1, 200, 0)
			panel:NumSlider("Money printer delay", "money_printer_time", 1, 60, 0)
			panel:NumSlider("Money printer amount", "money_printer_amount", 1, 200, 0)
			panel:NumSlider("Money printer capacity", "money_printer_max", 1, 10000, 0)
		end)
	end)
end
