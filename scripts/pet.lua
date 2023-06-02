require "class"
require "util"
local _G = GLOBAL
local PET_MAX = 10
local PI = _G.PI
local FindWalkableOffset = _G.FindWalkableOffset
local IsAnyPlayerInRange = _G.IsAnyPlayerInRange
local SpawnPrefab = _G.SpawnPrefab
local SpawnSaveRecord = _G.SpawnSaveRecord
local FRAMES = _G.FRAMES
local GetTime = _G.GetTime
local TheWorld = _G.TheWorld
local STRINGS = _G.STRINGS
local GetRandomKey = _G.GetRandomKey
local TheNet = _G.TheNet
local GetString = _G.GetString

local function DoEffects(pet)
	local x, y, z = pet.Transform:GetWorldPosition()
	SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
end

local function KillPet(pet)
	pet.components.health:Kill()
end

local function OnSpawnPet(inst, pet)
	if pet:HasTag("shadowminion") then
		--Delayed in case we need to relocate for migration spawning
		pet:DoTaskInTime(0, DoEffects)

		if not (inst.components.health:IsDead() or inst:HasTag("playerghost")) then
			inst.components.sanity:AddSanityPenalty(pet, TUNING.SHADOWWAXWELL_SANITY_PENALTY[string.upper(pet.prefab)])
			inst:ListenForEvent("onremove", inst._onpetlost, pet)
		elseif pet._killtask == nil then
			pet._killtask = pet:DoTaskInTime(math.random(), KillPet)
		end
	elseif inst._OnSpawnPet ~= nil then
		inst:_OnSpawnPet(pet)
	end
end

local function OnDespawnPet(inst, pet)
	if pet:HasTag("shadowminion") then
		DoEffects(pet)
		pet:Remove()
	elseif inst._OnDespawnPet ~= nil then
		inst:_OnDespawnPet(pet)
	end
end

local function OnDeath(inst)
	for k, v in pairs(inst.components.petleash:GetPets()) do
		if v:HasTag("shadowminion") and v._killtask == nil then
			v._killtask = v:DoTaskInTime(math.random(), KillPet)
		end
	end
end

local function OnReroll(inst)
	local todespawn = {}
	for k, v in pairs(inst.components.petleash:GetPets()) do
		if v:HasTag("shadowminion") then
			table.insert(todespawn, v)
		end
	end
	for i, v in ipairs(todespawn) do
		inst.components.petleash:DespawnPet(v)
	end
end

---------------------------------------------------------
local function SpawnWoby(inst)
    local player_check_distance = 40
    local attempts = 0

    local max_attempts = 30
    local x, y, z = inst.Transform:GetWorldPosition()

    local woby = GLOBAL.SpawnPrefab(TUNING.WALTER_STARTING_WOBY)
    --print(type(woby))
	--print(type(woby.LinkToPlayer))
    inst.woby = woby
    woby:LinkToPlayer(inst)  
    inst:ListenForEvent("onremove", inst._woby_onremove, woby)

    while true do
        local offset = FindWalkableOffset(inst:GetPosition(), math.random() * PI, player_check_distance + 1, 10)

        if offset then
            local spawn_x = x + offset.x
            local spawn_z = z + offset.z

            if attempts >= max_attempts then
                woby.Transform:SetPosition(spawn_x, y, spawn_z)
                break
            elseif not IsAnyPlayerInRange(spawn_x, 0, spawn_z, player_check_distance) then
                woby.Transform:SetPosition(spawn_x, y, spawn_z)
                break
            else
                attempts = attempts + 1
            end
        elseif attempts >= max_attempts then
            woby.Transform:SetPosition(x, y, z)
            break
        else
            attempts = attempts + 1
        end
    end

    return woby
end

local function OnWobyTransformed(inst, woby)
    if inst.woby ~= nil then
        inst:RemoveEventCallback("onremove", inst._woby_onremove, inst.woby)
    end
    inst.woby = woby
    inst:ListenForEvent("onremove", inst._woby_onremove, woby)
end

local function OnWobyRemoved(inst)
    inst.woby = nil
    inst._replacewobytask = inst:DoTaskInTime(1, function(i) i._replacewobytask = nil if i.woby == nil then SpawnWoby(i) end end)
end

local function OnRemoveEntity(inst)
    -- hack to remove pets when spawned due to session state reconstruction for autosave snapshots
    if inst.woby ~= nil and inst.woby.spawntime == GetTime() then
        inst:RemoveEventCallback("onremove", inst._woby_onremove, inst.woby)
        inst.woby:Remove()
    end

    if inst._story_proxy ~= nil and inst._story_proxy:IsValid() then
        inst._story_proxy:Remove()
    end
end
---------------------------------------------------------
local function StoryTellingDone(inst, story)
	if inst._story_proxy ~= nil and inst._story_proxy:IsValid() then
		inst._story_proxy:Remove()
		inst._story_proxy = nil
	end
end

local function StoryToTellFn(inst, story_prop)
	if not GLOBAL.TheWorld.state.isnight then
		return "NOT_NIGHT"
	end

	local fueled = story_prop ~= nil and story_prop.components.fueled or nil
	if fueled ~= nil and story_prop:HasTag("campfire") then
		if fueled:IsEmpty() then
			return "NO_FIRE"
		end

		local campfire_stories = STRINGS.STORYTELLER.WALTER["CAMPFIRE"]
		if campfire_stories ~= nil then
			if inst._story_proxy ~= nil then
				inst._story_proxy:Remove()
				inst._story_proxy = nil
			end
			inst._story_proxy = SpawnPrefab("walter_campfire_story_proxy")
			inst._story_proxy:Setup(inst, story_prop)

			local story_id = GetRandomKey(campfire_stories)
			return { style = "CAMPFIRE", id = story_id, lines = campfire_stories[story_id].lines }
		end
	end

	return nil
end
-----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
local function OnDespawn(inst)
    if inst.woby ~= nil then
        inst.woby:OnPlayerLinkDespawn()
    end
	--local abigail = inst.components.ghostlybond.ghost
    --if abigail ~= nil and abigail.sg ~= nil and not abigail.inlimbo then
	--	if not abigail.sg:HasStateTag("dissipate") then
	--		abigail.sg:GoToState("dissipate")
	--	end
      --  abigail:DoTaskInTime(25 * FRAMES, abigail.Remove)
    --end
end

local function OnSave(inst, data)
    data.woby = inst.woby ~= nil and inst.woby:GetSaveRecord() or nil
end

local function OnLoad(inst, data)
    if data ~= nil and data.woby ~= nil then
        inst._woby_spawntask:Cancel()
        inst._woby_spawntask = nil

        local woby = SpawnSaveRecord(data.woby)
        inst.woby = woby
        if woby ~= nil then
            if inst.migrationpets ~= nil then
                table.insert(inst.migrationpets, woby)
            end
            woby:LinkToPlayer(inst)

            woby.AnimState:SetMultColour(0,0,0,1)
            woby.components.colourtweener:StartTween({1,1,1,1}, 19*FRAMES)
            local fx = SpawnPrefab(woby.spawnfx)
            fx.entity:SetParent(woby.entity)

            inst:ListenForEvent("onremove", inst._woby_onremove, woby)
        end
    end
end
----------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)
	if not GLOBAL.TheWorld.ismastersim then
	    return
	end	
	----
	if inst.prefab ~= "walter" then
		--if GetModConfigData("walterswoby") then --给沃比
			inst:AddTag("dogrider")
			inst._woby_spawntask = inst:DoTaskInTime(0, function(i) i._woby_spawntask = nil SpawnWoby(i) end)
		    inst._woby_onremove = function(woby) OnWobyRemoved(inst) end
		    inst.OnWobyTransformed = OnWobyTransformed
		    
		    local Old_OnSave = inst.OnSave
		    local Old_OnLoad = inst.OnLoad
		    local Old_OnDespawn = inst.OnDespawn
		    inst.OnSave = function(...)
			    Old_OnSave(...)
			    OnSave(...)
			end
			inst.OnLoad = function(...)
			    Old_OnLoad(...)
			    OnLoad(...)
			end
			inst.OnDespawn = function(...)
			    Old_OnDespawn(...)
			    OnDespawn(...)
			end
		    --inst.OnSave = OnSave
		    --inst.OnLoad = OnLoad
		    --inst.OnDespawn = OnDespawn
		    inst:ListenForEvent("onremove", OnRemoveEntity)
		--end
		--if GetModConfigData("walterstag") then --不掉san，讲故事
		    --inst:AddTag("expertchef")
		    --inst:AddTag("pebblemaker")
		    --inst:AddTag("pinetreepioneer")
		    --inst:AddTag("allergictobees")
		    --inst:AddTag("slingshot_sharpshooter")
		    inst:AddTag("efficient_sleeper")
		    --inst:AddTag("dogrider")
		    inst:AddTag("nowormholesanityloss")
			inst:AddTag("storyteller") -- for storyteller component
			--inst.components.sanity:SetNegativeAuraImmunity(true)
		    --inst.components.sanity:SetPlayerGhostImmunity(true)
		    --inst.components.sanity:SetLightDrainImmune(true)
		    inst:AddComponent("storyteller")
			inst.components.storyteller:SetStoryToTellFn(StoryToTellFn)
			inst.components.storyteller:SetOnStoryOverFn(StoryTellingDone)
		--end
    end
    --
end)