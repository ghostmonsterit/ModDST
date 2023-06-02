local _G = GLOBAL
local require = _G.require
local next = _G.next
local ExecuteConsoleCommand = _G.ExecuteConsoleCommand
local TheSim = _G.TheSim
local TheNet = _G.TheNet
local TheInput = _G.TheInput

local keys = {"KP_0", "KP_1","KP_2","KP_3", "KP_4","KP_5","KP_6","KP_7","KP_8","KP_9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","LAlt","RAlt","LCtrl","RCtrl","LShift","RShift","Tab","Capslock","Space","Minus","Equals","Backspace","Insert","Home","Delete","End","Pageup","Pagedown","Print","Scrollock","Pause","Period","Slash","Semicolon","Leftbracket","Rightbracket","Backslash","Up","Down","Left","Right"}

-- local function GetKeyFromConfig(config)
    -- local key = GetModConfigData(config, true)
    -- if type(key) == "string" and _G:rawget(key) then
        -- key = _G[key]
    -- end
    -- return type(key) == "number" and key or -1
-- end

-- no_tp is true when don't want cave tp and save position
local function SendCommand(fnstr, kuid, no_tp)
	local x, _, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
	local is_valid_time_to_use_remote = TheNet:GetIsClient() and TheNet:GetIsServerAdmin()
	local send_str = string.format("local player = LookupPlayerInstByUserID('%s') if player then " .. fnstr .. (not no_tp and " else local cave = GetClosestInstWithTag('migrator', ThePlayer, 1000) c_goto(cave) end" or " end"), kuid)
	if is_valid_time_to_use_remote then
		TheNet:SendRemoteExecute(send_str, x, z)
		if not no_tp then
			SavePositions()
		end
	else
		ExecuteConsoleCommand(send_str)
	end
end


local function InGame()
    return TheSim:FindFirstEntityWithTag("minimap") or nil
end

--F1
local Frozen = function()
	if not InGame() then return end
	fn_str = string.format("local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 15) for k,obj in pairs(ents) do if not obj:HasTag('player') and obj ~= TheWorld and obj.AnimState and obj.Transform and obj.components and obj.components.freezable ~= nil then obj.components.freezable:AddColdness(1, 60) obj.components.freezable:SpawnShatterFX() end end", 2)
	SendCommand(fn_str ,_G.ThePlayer.userid, true) 
end 
TheInput:AddKeyDownHandler(_G.KEY_F1, Frozen)

--NUM 2
local SendLighting = function()
	if not InGame() then return end
	fn_str = string.format('TheWorld:PushEvent("ms_sendlightningstrike", ThePlayer:GetPosition())')
	SendCommand(fn_str ,_G.ThePlayer.userid, true)
end
TheInput:AddKeyDownHandler(_G.KEY_KP_2, SendLighting)

--NUM 0
local HARVEST = function()
	if not InGame() then return end
	fn_str = string.format('if not player or player:HasTag("playerghost") then return end local function tryharvest(inst) local objc = inst.components if objc.crop ~= nil then objc.crop:Harvest(player) elseif objc.harvestable ~= nil then objc.harvestable:Harvest(player) elseif objc.stewer ~= nil then objc.stewer:Harvest(player) elseif objc.dryer ~= nil then objc.dryer:Harvest(player) elseif objc.occupiable ~= nil and objc.occupiable:IsOccupied() then local item = objc.occupiable:Harvest(player) if item ~= nil then player.components.inventory:GiveItem(item) end elseif objc.pickable ~= nil and objc.pickable:CanBePicked() then objc.pickable:Pick(player) end end local function harvesting() local x,y,z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 30) for k, obj in pairs(ents) do if not obj:HasTag("player") and not obj:HasTag("flower") and not obj:HasTag("trap") and not obj:HasTag("mine") and not obj:HasTag("cage") and obj ~= TheWorld and obj.AnimState and obj.components and obj.prefab and not string.find(obj.prefab, "mandrake") then tryharvest(obj) end end end harvesting()')
	SendCommand(fn_str ,_G.ThePlayer.userid, true)
end
TheInput:AddKeyDownHandler(_G.KEY_KP_0, HARVEST)


--NUM 1
local PICK = function()
	if not InGame() then return end
	fn_str = string.format('if not player or player:HasTag("playerghost") then return end local inv = player.components.inventory local x, y, z = player.Transform:GetWorldPosition() local ents = TheSim:FindEntities(x, y, z, 30, { "_inventoryitem" }, { "INLIMBO", "NOCLICK", "catchable", "fire" }) local baits = { ["powcake"] = true, ["pigskin"] = true, ["winter_food4"] = true, } local function Wall(item) local xx, yy ,zz = item.Transform:GetWorldPosition() local nents = TheSim:FindEntities(xx, yy, zz, 3) local targets = 0 for _, vv in ipairs(nents) do if vv:HasTag("wall") and vv.components.health then targets = targets + 1 end end return targets end for _, v in ipairs(ents) do local c = v.components if c.inventoryitem ~= nil and c.inventoryitem.canbepickedup and c.inventoryitem.cangoincontainer and not c.inventoryitem:IsHeld() and not v:HasTag("flower") and not v:HasTag("trap") and not v:HasTag("mine") and not v:HasTag("cage") and not string.find(v.prefab, "mooneye") and inv and inv:CanAcceptCount(v, 1) > 0 then if c.trap ~= nil and c.trap:IsSprung() then c.trap:Harvest(player) else if baits[v.prefab] then if Wall(v) < 7 then inv:GiveItem(v) end else if c.bait then if not c.bait.trap then inv:GiveItem(v) end else inv:GiveItem(v) end end end end end')
	SendCommand(fn_str ,_G.ThePlayer.userid, true)
end
TheInput:AddKeyDownHandler(_G.KEY_KP_1, PICK)
--NUM 5 
local OneResurrect = function()
	if not InGame() then return end
	fn_str = string.format('for k,v in pairs(AllPlayers) do v:PushEvent("respawnfromghost") end')
	SendCommand(fn_str ,_G.ThePlayer.userid, true)
end
TheInput:AddKeyDownHandler(_G.KEY_HOME, OneResurrect)

--Unlock Teck
local UnlockTech = function()
	if not InGame() then return end
	fn_str = string.format('player.components.builder:UnlockRecipesForTech({SCIENCE = 10, MAGIC = 10, ANCIENT = 10, SHADOW = 10, CARTOGRAPHY = 10})')
	SendCommand(fn_str ,_G.ThePlayer.userid, true)
end
TheInput:AddKeyDownHandler(_G.KEY_INSERT, UnlockTech)
----NUM 7 to spawn hound
-- local SpawnHound = function()
	-- if not InGame() then return end
	-- fn_str = string.format('c_spawn("hound", 3)')
	-- SendCommand(fn_str ,_G.ThePlayer.userid, true)
-- end
-- TheInput:AddKeyDownHandler(GetKeyFromConfig("SpawnHound"), SpawnHound)
----NUM 8 to spawn Bearger
-- local SpawnBearger = function()
	-- if not InGame() then return end
	-- fn_str = string.format('c_spawn("bearger", 1)')
	-- SendCommand(fn_str ,_G.ThePlayer.userid, true)
-- end
-- TheInput:AddKeyDownHandler(GetKeyFromConfig("SpawnBearger"), SpawnBearger)

----NUM 9 to spawn Warg
-- local SpawnWarg = function()
	-- if not InGame() then return end
	-- fn_str = string.format('c_spawn("warg", 1)')
	-- SendCommand(fn_str ,_G.ThePlayer.userid, true)
-- end
-- TheInput:AddKeyDownHandler(GetKeyFromConfig("SpawnWarg"), SpawnWarg)

----NUM 0 to spawn Deerclops
-- local SpawnDeerclops = function()
	-- if not InGame() then return end
	-- fn_str = string.format('c_spawn("deerclops", 1)')
	-- SendCommand(fn_str ,_G.ThePlayer.userid, true)
-- end
-- TheInput:AddKeyDownHandler(GetKeyFromConfig("SpawnDeerclops"), SpawnDeerclops)

----F1 to spawn Toadstool
-- local SpawnToadstool = function()
	-- if not InGame() then return end
	-- fn_str = string.format('c_spawn("toadstool", 1)')
	-- SendCommand(fn_str ,_G.ThePlayer.userid, true)
-- end
-- TheInput:AddKeyDownHandler(GetKeyFromConfig("SpawnToadstool"), SpawnToadstool)