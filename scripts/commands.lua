local _G = GLOBAL
local TheNet = _G.TheNet
local TheInput = _G.TheInput
local require = _G.require
local next = _G.next
local ExecuteConsoleCommand = _G.ExecuteConsoleCommand
local TheSim = _G.TheSim


local function GetPlayerById(playerid)
	for _, v in ipairs(_G.AllPlayers) do
		if v ~= nil and v.userid and v.userid == playerid then
			return v
		end
	end
	return nil
end

local function playerSay(player, message, time)
	if time == nil then time = 5 end
	player.components.talker:Say(message , time)
end

local function systemAnnounce(player, message)
	player:DoTaskInTime(0.5, function()
		TheNet:Announce(message)
	end)
end


local Networking_Say = _G.Networking_Say
_G.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, self, inst, data, ...)
	Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, self, inst, data, ...)

	local player = GetPlayerById(userid)
	local world = _G.TheWorld
	if(player == nil) then return end

	
	if message == "!nv" then
		local tips = name.." is changing characters"
		systemAnnounce(player, tips)
		if not player.sg:HasStateTag("busy") then
			if player.components and player.components.inventory then
				player.components.inventory:DropEverything(true)
			end
			world:PushEvent("ms_playerdespawnanddelete", player) 
		end
	end
	
	if message == "!admin" then
		if _G.TheNet and ((_G.TheNet:GetIsServer() and _G.TheNet:GetServerIsDedicated()) or (_G.TheNet:GetIsClient() and _G.TheNet:GetIsServerAdmin()) or (_G.TheNet:GetIsClient() and _G.TheNet:GetServerIsClientHosted())) then
			systemAnnounce(player, name.." is admin")
		else
			systemAnnounce(player, name.." is not admin")
		end
	end
	
	
	if message == "!check" then
		if _G.TheNet then
			systemAnnounce(player, name.."  _G.TheNet")--
		end
		if _G.TheNet:GetIsServer()then
			systemAnnounce(player, name.."  _G.TheNet:GetIsServer()")--
		end
		if _G.TheNet:GetServerIsDedicated()then
			systemAnnounce(player, name.."  _G.TheNet:GetIsServerDedicated()")
		end
		if _G.TheNet:GetIsClient() then
			systemAnnounce(player, name.."  _G.TheNet:GetIsClient()")
		end
		if _G.TheNet:GetIsServerAdmin() then
			systemAnnounce(player, name.."  _G.TheNet:GetIsServerAdmin()")--
		end
		if _G.TheNet:GetServerIsClientHosted() then
			systemAnnounce(player, name.." _G.TheNet:GetServerIsClientHosted()")--
		end
	end
	if message == "!checks" then
		if GLOBAL.TheNet:GetUserID() == "KU_6BQkk1qw" then
			systemAnnounce(player, name.."  OKE")
		end
	end

	
	if message == "!unlock" then
		local builder = player.components.builder
		local inventory = player.components.inventory

		if builder and inventory then
			player:AddComponent("builder")
			player.components.builder:UnlockRecipesForTech({SCIENCE = 10, MAGIC = 10, ANCIENT = 10, SHADOW = 10, CARTOGRAPHY = 10})
		end
	end
	
	if message == "!ww3" then
		local p = player.components.bloomness if player and not player:HasTag("playerghost") and p then p:SetLevel(3) end
	end
	
	if message == "!abi3" then
		local v = player.components.ghostlybond if player and not player:HasTag("playerghost") and v then v:SetBondLevel(3) end
	end

	
	
end