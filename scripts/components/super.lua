

local function findprefab(list,prefab)
    for index,value in pairs(list) do
        if value == prefab then
            return true
        end
    end
end

local Super = Class(function(self, inst)
    self.inst = inst
	self.effectstype = 1
end)

function Super:fishing(inst)
    inst:ListenForEvent("equip", function(inst, data)
        if data.item and data.item.components.fishingrod then
            self.fishtimemin = data.item.components.fishingrod.minwaittime
            self.fishtimemax = data.item.components.fishingrod.maxwaittime
            data.item.components.fishingrod:SetWaitTimes(0.5, 0.5)
        end
    end)
    inst:ListenForEvent("unequip", function(inst, data)
        if data.item and data.item.components.fishingrod then
            data.item.components.fishingrod:SetWaitTimes(self.fishtimemin, self.fishtimemax)
        end
    end)
end

function Super:picking(inst)
    inst:ListenForEvent("picksomething", function(inst, data)
        if data.object and data.object.components.pickable and not data.object.components.trader then
            if data.object.components.pickable.product ~= nil then
                local item = SpawnPrefab(data.object.components.pickable.product)
                if item.components.stackable then
                    item.components.stackable:SetStackSize(data.object.components.pickable.numtoharvest)
                end
                inst.components.inventory:GiveItem(item, nil, data.object:GetPosition())
            end
        end
    end)
end

function Super:choping(inst)
    inst:ListenForEvent("working", function(inst, data)
        if data.target and data.target.components.workable and data.target:HasTag("tree") then
            local workable = data.target.components.workable
            if data.target.components.workable.action == ACTIONS.CHOP then
            	local equipitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                --if equipitem ~= nil and (equipitem.prefab == "axe" or equipitem.prefab == "goldenaxe" or equipitem.prefab == "moonglassaxe" or equipitem.prefab == "multitool_axe_pickaxe"    ) then
            	if equipitem ~= nil  and equipitem.components.finiteuses ~= nil then
            
                	local itemuses =   equipitem.components.finiteuses:GetUses() 
                	if  itemuses > 0 then
                		if workable.workleft >= 1 then
                			if equipitem.components.finiteuses.consumption[ACTIONS.CHOP] ~= nil then
                				local uses2 = equipitem.components.finiteuses.consumption[ACTIONS.CHOP]
                				equipitem.components.finiteuses:Use(workable.workleft*uses2)
                			else 
                				equipitem.components.finiteuses:Use(workable.workleft)
                			end
						end
                	end
            	end
            end
            workable.workleft = 0
        end
    end)
end

function Super:cooking(inst)
    local COOK = ACTIONS.COOK
	local old_cook_fn = COOK.fn
	COOK.fn = function(act, ...)
	local result = old_cook_fn(act)
	local stewer = act.target.components.stewer
		if result and stewer ~= nil then
			if act.doer:HasTag("expertchef") ~= true then
				act.doer:AddTag("expertchef")
			end
			local fn = stewer.task.fn
			stewer.task:Cancel()
			fn(act.target, stewer)

		end
	end
end



function Super:goodman(inst)
    inst:DoPeriodicTask(1, function() 
		local pos = Vector3(inst.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 6)
		for k,v in pairs(ents) do
			if v.prefab then
				if v.prefab == "pigman" or v.prefab == "bunnyman" then
					if v.components.follower.leader == nil
					and not v:HasTag("werepig")
					and not v:HasTag("guard") then
						if v.components.combat:TargetIs(inst) then
							v.components.combat:SetTarget(nil)
						end
						inst.components.leader:AddFollower(v)
					end
				end
			end
		end
    end)
end

--首领 标签效果
function Super:goodman2(inst)
    inst:DoPeriodicTask(1, function()
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if item ~= nil and item.prefab == "hivehat"  then
            local pos = Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 6)
            for k,v in pairs(ents) do
                if v.prefab then
                    if v.prefab == "pigman" or v.prefab == "bunnyman" 
                        or v.prefab == "hound"
                        or v.prefab == "firehound"
                        or v.prefab == "icehound"
                        or v.prefab == "spider"
                        or v.prefab == "spider_hider"
                        or v.prefab == "spider_spitter"
                        or v.prefab == "spider_warrior"
                        or v.prefab == "spider_moon" --月岛蜘蛛
                        or v.prefab == "merm" --鱼人
                        or v.prefab == "mermguard" --鱼人守卫
                        --or v.prefab == "catcoon"
                        or v.prefab == "spider_dropper" then
                        if v.components.follower and v.components.follower.leader == nil
                        and not v:HasTag("werepig")
                        --and not v:HasTag("guard")
                         then
                            if v.components.combat:TargetIs(inst) then
                                v.components.combat:SetTarget(nil)
                            end
                            if inst.components.leader and inst.components.leader.numfollowers < 50  then
                                inst.components.leader:AddFollower(v)
                            end
                        end
                    end
                end
            end
        end
    end)
end

function Super:doubledrop(inst)
    inst:ListenForEvent("killed", function(inst, data)
        if data.victim.components.lootdropper then
            if data.victim.components.freezable or data.victim:HasTag("monster") then
                data.victim.components.lootdropper:DropLoot()
            end
        end
    end)
end

function Super:fireflylight(inst)
	if inst._fireflylight then inst._fireflylight:Remove() end
	inst._fireflylight = SpawnPrefab("minerhatlight")
	inst._fireflylight.Light:SetRadius(0.5)
	inst._fireflylight.Light:SetFalloff(.8)
	inst._fireflylight.Light:SetIntensity(.6)
	inst._fireflylight.Light:SetColour(255/255,255/255,255/255)
	inst._fireflylight.entity:SetParent(inst.entity)
	if TheWorld.components.worldstate.data.isday then
		inst._fireflylight.Light:SetIntensity(0)
		inst._fireflylight.Light:Enable(false)
	end
	inst:WatchWorldState("startday", function()
		for i=1, 100 do
			inst:DoTaskInTime(i/25, function()
				inst._fireflylight.Light:SetIntensity(.5-i/100*.5)
			end)
		end
		inst:DoTaskInTime(4, function() inst._fireflylight.Light:Enable(false) end)
	end)
	inst:WatchWorldState("startdusk", function()
		inst._fireflylight.Light:Enable(true)
		for i=1, 100 do
			inst:DoTaskInTime(i/25, function()
				inst._fireflylight.Light:SetIntensity(i/100*.5)
			end)
		end
	end)
end


local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("balloon") or
                victim:HasTag("groundspike") or
                victim:HasTag("smashable") or
                victim:HasTag("companion"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

function Super:lifesteal(inst)
    inst:ListenForEvent("onhitother", function(inst, data)
		if data.target and not inst.components.health:IsDead() and IsValidVictim(data.target) then	
			local damage = inst.components.combat:CalcDamage(data.target, data.weapon)
			--local damage = data.weapon ~= nil and data.weapon.components.weapon.damage or inst.components.combat.defaultdamage
			inst.components.health:DoDelta(damage*0.05, false, "lifesteal")
		end
    end)
end

function Super:buildmaster(inst)
    inst.components.builder.ingredientmod = .5
    inst:ListenForEvent("equip", function(inst, data)
        if data.item and data.item.prefab == "greenamulet" then
            inst.components.builder.ingredientmod = .5
        end
    end)
    inst:ListenForEvent("unequip", function(inst, data)
        if data.item and data.item.prefab == "greenamulet" then
            inst.components.builder.ingredientmod = .5
        end
    end)
end

function Super:nanobots(inst)
    inst:DoPeriodicTask(1, function()
		local inventory = inst.components.inventory
		if inventory then
			for k, v in pairs(inventory.equipslots) do
				if not findprefab(magiclist, v.prefab) then
					if v.components.finiteuses then
						local p = v.components.finiteuses:GetPercent()
						p = math.min(p+0.003, 1.0)
						v.components.finiteuses:SetPercent(p)
					end
					if v.components.armor then
						local p = v.components.armor:GetPercent()
						p = math.min(p+0.003, 1.0)
						v.components.armor:SetPercent(p)
					end
					if v.components.fueled then
						local p = v.components.fueled:GetPercent()
						p = math.min(p+0.003, 1.0)
						v.components.fueled:SetPercent(p)
					end
				end
			end
		end
    end)
end

magiclist = {"amulet", "blueamulet", "purpleamulet", "firestaff", "icestaff", "telestaff", "orangestaff", "greenstaff", "yellowstaff","orangeamulet", "greenamulet", "yellowamulet", "opalstaff",}
function Super:archmage(inst)
    inst:DoPeriodicTask(10, function()
		local inventory = inst.components.inventory
		if inventory then
			for k, v in pairs(inventory.equipslots) do
				if findprefab(magiclist, v.prefab) then  
					if v.components.finiteuses then
						local p = v.components.finiteuses:GetPercent()
						p = math.min(p+0.01, 1.0)
						v.components.finiteuses:SetPercent(p)
					end
					if v.components.armor then
						local p = v.components.armor:GetPercent()
						p = math.min(p+0.01, 1.0)
						v.components.armor:SetPercent(p)
					end
				end
			end
		end
    end)
end

function Super:cheatdeath(inst)
	------------- Bat tu sau khi thap mau hoi lai sau moi 15 phut ------------------------------
		local onCoolDown = false
			inst:ListenForEvent("minhealth", function(player, data)
				if not onCoolDown and player.components.health.currenthealth <= 0 then
					player.components.health.currenthealth = 5
					player.components.health:SetInvincible(true)
					if player._fx ~= nil then
						player._fx:kill_fx()
					end
					player._fx = SpawnPrefab("forcefieldfx")
					player._fx.entity:SetParent(player.entity)
					player._fx.Transform:SetPosition(0, 0.2, 0)
					local b1 = SpawnPrefab("ghost_transform_overlay_fx")
					b1.entity:SetParent(player.entity)
					b1.Transform:SetPosition(0, -1.65, 0)
					local b2 = SpawnPrefab("bramblefx_trap")
					b2.entity:SetParent(player.entity)
					b2.Transform:SetPosition(0, 0, 0)
					-- local b3 = SpawnPrefab("groundpoundring_fx")
					-- b3.entity:SetParent(player.entity)
					-- b3.Transform:SetPosition(0, 2, 0)
					-- local b4 = SpawnPrefab("lavaarena_creature_teleport_small_fx")
					-- b4.entity:SetParent(player.entity)
					-- b4.Transform:SetPosition(0, 0, 0)
					local b5 = SpawnPrefab("superjump_fx")
					b5.entity:SetParent(player.entity)
					b5.Transform:SetPosition(0, 0, 0)
					player.SoundEmitter:PlaySound("dontstarve/common/lava_arena/spawn")
					
					player:DoTaskInTime(0.5, function(player)
						local angle = 0
						local pos = Vector3(inst.Transform:GetWorldPosition())
						for i=1, 12 do
							local bomb = SpawnPrefab("explode_small")
							local z = pos.z + 2.5*math.cos(angle*math.pi/180)
							local x = pos.x + 2.5*math.sin(angle*math.pi/180)
							bomb.Transform:SetPosition(x, pos.y, z)
							angle = angle + 360/12
						end
						local combat_tag = {"_combat"}
						local innocent_tag = {"bird","wall","glommer","butterfly","berrythief","rabbit","mole","grassgekko","chester","hutch","player"}
						local musthave_tag = {"_combat","critter","woby"} or {"_health"}
						local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 10, combat_tag,innocent_tag,musthave_tag)
						local damage = 1000
						for k,v in pairs(ents) do
							if v and v.components.combat and v:HasTag("_combat") then
								v.components.combat:GetAttacked(inst, damage)
							end
						end
					end)
					
					player:DoTaskInTime(1800, function(player) -- thoi gian hoi sinh bat tu
						onCoolDown = false
						local cool = SpawnPrefab("staffcastfx")				
						cool.entity:SetParent(player.entity)
						cool.Transform:SetPosition(0, 0, 0)
						player.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
					end)
					
					player:DoTaskInTime(5, function(player) 
						if player._fx ~= nil then
							player._fx:kill_fx()
							player._fx = nil
						end
						player.components.health:SetInvincible(false)
						onCoolDown = true
					end)
				end
			end)
end

function Super:refresh(inst)
    inst:DoPeriodicTask(1, function()
        if self.refresh then
            --物品栏反鲜
            for k,v in pairs(inst.components.inventory.itemslots) do
                if v and v.components.perishable then
                    v.components.perishable:ReducePercent(-.005)
                end
            end
            --装备栏反鲜
            for k,v in pairs(inst.components.inventory.equipslots) do
                if v and v.components.perishable then
                    v.components.perishable:ReducePercent(-.005)
                end
            end
            --背包反鲜
            for k,v in pairs(inst.components.inventory.opencontainers) do
                if k and k:HasTag("backpack") and k.components.container then
                    for i,j in pairs(k.components.container.slots) do
                        if j and j.components.perishable then
                            j.components.perishable:ReducePercent(-.005)
                        end
                    end
                end
            end
        end
    end)
end

rocklist = {"marbletree", "marblepillar",
			"rock_ice", "rock_ice_tall", "rock_ice_medium", "rock_ice_short",
			"stalagmite", "stalagmite_full", "stalagmite_med", "stalagmite_low", 
			"stalagmite_tall", "stalagmite_tall_full", "stalagmite_tall_med", "stalagmite_tall_low", 
}

function Super:minemaster(inst)
	inst:ListenForEvent("working", function(inst, data)
		if data.target and (data.target:HasTag("boulder") or data.target:HasTag("statue") or findprefab(rocklist, data.target.prefab)) then
			local workable = data.target.components.workable
			workable.workleft = 0
		end
	end)
end

function Super:alltag(inst)
	inst:RemoveTag("scarytoprey")
	inst:AddTag("animallover")
	inst:AddTag("fastpick")
		if inst:HasTag("expertchef") ~= true then
            inst:AddTag("expertchef")
        end
        if inst:HasTag("fastbuilder") ~= true then
            inst:AddTag("fastbuilder")
        end
	inst:AddTag("perkchef")
	inst:AddTag("masterchef")
	inst:AddTag("professionalchef")
	inst:AddComponent("reader")
end
function Super:electricattack(inst)
   
        if inst.components.debuffable ~= nil and inst.components.debuffable:IsEnabled() and
            not (inst.components.health ~= nil and inst.components.health:IsDead()) and
            not inst:HasTag("playerghost") then
            inst.components.debuffable:AddDebuff("buff_electricattack", "buff_electricattack")
        end
    inst:DoPeriodicTask((TUNING.BUFF_ELECTRICATTACK_DURATION*0.9), function()

            if inst.components.debuffable ~= nil and inst.components.debuffable:IsEnabled() and
                not (inst.components.health ~= nil and inst.components.health:IsDead()) and
                not inst:HasTag("playerghost") then
                inst.components.debuffable:AddDebuff("buff_electricattack", "buff_electricattack")
            end

    end)
    inst:ListenForEvent("respawnfromghost", function(inst, data)
        if  self.electric >= 1  then
            if inst.components.debuffable ~= nil and inst.components.debuffable:IsEnabled() and
                not (inst.components.health ~= nil and inst.components.health:IsDead()) and
                not inst:HasTag("playerghost") then
                inst.components.debuffable:AddDebuff("buff_electricattack", "buff_electricattack")
            end  
        end
        
    end)
end




local function OnCooldown(inst)
    inst._cdtaskachiv = nil -- Đặt lại biến cooldown của hành động thành nil
end

local function OnCooldown2(inst)
    inst._attackcheck_moon_13 = nil -- Đặt lại biến cooldown của hành động thành nil
end

function Super:freezeattack(inst)
    inst:ListenForEvent("attacked", function(inst, data)
        -- Xử lý khi bị tấn công
        if data and data.attacker and data.attacker.components and data.attacker.components.freezable ~= nil and data.attacker.components.burnable ~= nil then
            if data.attacker.components.health and data.attacker.components.health.maxhealth >= 1000 then
                local rand1 = math.random()
                if rand1 <= 0.5 then
                    data.attacker.components.freezable.resistance = 1
                    data.attacker.components.freezable:AddColdness(3, 19)
                    data.attacker.components.freezable:SpawnShatterFX()
                else
					data.attacker.components.burnable:Ignite()
					data.attacker.components.burnable:SetEffectLevel(1) -- Đặt mức độ hiệu ứng lửa là 1
					data.attacker.components.burnable:SetFireStunTime(0.4) -- Đặt thời gian choáng khi cháy là 0.2 giây
                end
            else
                local rand1 = math.random()
                if rand1 <= 0.5 then
                    data.attacker.components.freezable.resistance = 1
                    data.attacker.components.freezable:AddColdness(3, 9)
                    data.attacker.components.freezable:SpawnShatterFX()
                else
					data.attacker.components.burnable:Ignite()
					data.attacker.components.burnable:SetEffectLevel(2) -- Đặt mức độ hiệu ứng lửa là 1
					data.attacker.components.burnable:SetFireStunTime(0.1) -- Đặt thời gian choáng khi cháy là 0.2 giây
                end
            end
        end

        -- Xử lý khi thực hiện hành động tấn công
        if inst._cdtaskachiv == nil and data ~= nil and not data.redirected and inst.components.health and not inst.components.health:IsDead() and not inst:HasTag("playerghost") then
            inst._cdtaskachiv = inst:DoTaskInTime(.5, OnCooldown)
            SpawnPrefab("bramblefx_armor"):SetFXOwner(inst) -- Tạo hiệu ứng "bramblefx_armor" và gắn nó với "inst"

            if data and data.attacker and data.attacker.components.combat and data.attacker.components.combat.defaultdamage >= 45 and inst.components.health and not inst.components.health:IsDead() and not inst:HasTag("playerghost") then
                SpawnPrefab("bramblefx_trap"):SetFXOwner(inst) -- Tạo hiệu ứng "bramblefx_trap" và gắn nó với "inst"
            end

            if data and data.attacker and data.attacker.components.combat and data.attacker.components.combat.defaultdamage >= 60 and inst.components.health and not inst.components.health:IsDead() and not inst:HasTag("playerghost") then
                SpawnPrefab("bramblefx_trap"):SetFXOwner(inst) -- Tạo hiệu ứng "bramblefx_trap" và gắn nó với "inst"
            end

            if inst.SoundEmitter ~= nil then
                inst.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus") -- Phát âm thanh "cactus"
            end
        end
    end)

    inst:ListenForEvent("onhitother", function(inst, data)
        local target = data.target
        if target and target.components.freezable ~= nil and not target:HasTag("wall") and self.attackcheck ~= true then
            local rand2 = math.random()
            if rand2 <= 0.15 then
                self.attackcheck = true
                data.target.components.freezable:AddColdness(3, 9)
                data.target.components.freezable:SpawnShatterFX()
                inst:DoTaskInTime(.1, function() self.attackcheck = false end)
            end
        end

        -- Ghi lại thông tin về kẻ tấn công trong vòng 5 giây
        if target and target.components and target.components.freezable ~= nil and not target:HasTag("wall") and self.attackedcheck ~= true then
            if target.attacker_userid and #target.attacker_userid > 0 then
                local add_userid = true

                for i = 1, #target.attacker_userid do
                    if target.attacker_userid[i] == inst.userid then
                        add_userid = false
                    end
                end

                if add_userid then
                    table.insert(target.attacker_userid, inst.userid)
                end

                -- Xóa thông tin sau 5 giây nếu không có tấn công nào khác
                if inst.mod_add_userid == nil then
                    inst.mod_add_userid = inst:DoTaskInTime(8, function(inst, target)
                        if target and target.attacker_userid and #target.attacker_userid > 0 then
                            local remove_userid = 0
                            for i = 1, #target.attacker_userid do
                                if target.attacker_userid[i] == inst.userid then
                                    remove_userid = i
                                end
                            end

                            if remove_userid > 0 then
                                table.remove(target.attacker_userid, remove_userid)
                            end

                            inst.mod_add_userid = nil
                        end
                    end)
                elseif inst.mod_add_userid ~= nil then
                    -- Nếu có tấn công liên tục trong vòng 5 giây, cập nhật lại thời gian xóa thông tin
                    inst.mod_add_userid:Cancel()
                    inst.mod_add_userid = inst:DoTaskInTime(8, function(inst, target)
                        if target and target.attacker_userid and #target.attacker_userid > 0 then
                            local remove_userid = 0
                            for i = 1, #target.attacker_userid do
                                if target.attacker_userid[i] == inst.userid then
                                    remove_userid = i
                                end
                            end

                            if remove_userid > 0 then
                                table.remove(target.attacker_userid, remove_userid)
                            end

                            inst.mod_add_userid = nil
                        end
                    end)
                end
            else
                target.attacker_userid = {}
                table.insert(target.attacker_userid, inst.userid)

                -- Xóa thông tin sau 5 giây nếu không có tấn công nào khác
                if inst.mod_add_userid == nil then
                    inst.mod_add_userid = inst:DoTaskInTime(8, function(inst, target)
                        if target and target.attacker_userid and #target.attacker_userid > 0 then
                            local remove_userid = 0
                            for i = 1, #target.attacker_userid do
                                if target.attacker_userid[i] == inst.userid then
                                    remove_userid = i
                                end
                            end

                            if remove_userid > 0 then
                                table.remove(target.attacker_userid, remove_userid)
                            end

                            inst.mod_add_userid = nil
                        end
                    end)
                elseif inst.mod_add_userid ~= nil then
                    inst.mod_add_userid:Cancel()
                    inst.mod_add_userid = inst:DoTaskInTime(8, function(inst, target)
                        if target and target.attacker_userid and #target.attacker_userid > 0 then
                            local remove_userid = 0
                            for i = 1, #target.attacker_userid do
                                if target.attacker_userid[i] == inst.userid then
                                    remove_userid = i
                                end
                            end

                            if remove_userid > 0 then
                                table.remove(target.attacker_userid, remove_userid)
                            end

                            inst.mod_add_userid = nil
                        end
                    end)
                end
            end

            inst:DoTaskInTime(.2, function(target) target.attackedcheck = false end)
        end
    end)
end


local function ondeployitem(inst, data)
    if inst and inst.components.sanity and inst.components.achievementability and inst.components.achievementability.plantfriend then
        if data and data.prefab ~= "fossil_piece" then
            inst.components.sanity:DoDelta(TUNING.SANITY_SUPERTINY*5)
        end
    end
end

function Super:plantfriend(inst)
    if inst and inst.prefab ~= "wormwood" then
        inst:AddTag("plantkin")
        inst:AddTag("healonfertilize")
        inst:AddTag("achiveplantkin")      
        inst:ListenForEvent("deployitem", ondeployitem)
    end
    if inst.prefab ~= "wormwood" then 
        inst.planttask = nil          
        inst.pollenpool = { 1, 2, 3, 4, 5 }
        for i = #inst.pollenpool, 1, -1 do
               --randomize in place
            table.insert(inst.pollenpool, table.remove(inst.pollenpool, math.random(i)))
        end
        inst.plantpool = { 1, 2, 3, 4 }
        for i = #inst.plantpool, 1, -1 do
                --randomize in place
            table.insert(inst.plantpool, table.remove(inst.plantpool, math.random(i)))
        end      
    end 
    local PLANTS_RANGE = 1.5
    local MAX_PLANTS = 20
    --PlantTick 
    inst:DoPeriodicTask(.21, function()
    if  inst.prefab == "wormwood" then
        return
    end
    --开关

    if inst.sg:HasStateTag("ghostbuild") or inst.components.health:IsDead() or not inst.entity:IsVisible() then
        return
    end

    if  inst.components.drownable ~= nil and inst.components.drownable:IsOverWater()  then
        return
    end
	
    local fx_name = "wormwood_plant_fx"

    local fx_namef = "fernsfx"   --   fernsfx

    local fx_nameh = "healflowersfx"   --   healflowersfx

    local x, y, z = inst.Transform:GetWorldPosition()    
    if #TheSim:FindEntities(x, y, z, PLANTS_RANGE, { fx_name, fx_namef, fx_nameh }) < MAX_PLANTS then
        
        local map = TheWorld.Map
        local pt = Vector3(0, 0, 0)
        local offset = FindValidPositionByFan(
            math.random() * 2 * PI,
            math.random() * PLANTS_RANGE,
            3,
            function(offset)
                pt.x = x + offset.x
                pt.z = z + offset.z
                local tile = map:GetTileAtPoint(pt:Get())

                return tile ~= GROUND.IMPASSABLE
                    and tile ~= GROUND.INVALID
                    and #TheSim:FindEntities(pt.x, 0, pt.z, .5, { fx_name, fx_namef, fx_nameh}) < 3
                    and map:IsDeployPointClear(pt, nil, .5)
                    and not map:IsPointNearHole(pt, .4)
            end
        )
        if offset ~= nil then
            local plant = SpawnPrefab(fx_name)
            -- local plants = SpawnPrefab(fx_name)
			if plant ~= nil then
				plant.Transform:SetPosition(x + offset.x, 0, z + offset.z)
				local rnd = math.random()
				rnd = table.remove(inst.plantpool, math.clamp(math.ceil(rnd * rnd * #inst.plantpool), 1, #inst.plantpool))
				table.insert(inst.plantpool, rnd)
				plant:SetVariation(rnd)  
			end
			-- if plants ~= nil then
				-- plants.Transform:SetPosition(x - offset.x, 0, z - offset.z)
				-- local rnd = math.random()
				-- rnd = table.remove(inst.plantpool, math.clamp(math.ceil(rnd * rnd * #inst.plantpool), 1, #inst.plantpool))
				-- table.insert(inst.plantpool, rnd)
				-- plants:SetVariation(rnd)  
			-- end
			local ferns = SpawnPrefab(fx_namef)
            if ferns ~= nil then
                ferns.Transform:SetPosition(x - offset.x, 0, z - offset.z)
				ferns.Transform:SetScale(.4,.4,0)
			end
			local healflowers = SpawnPrefab(fx_nameh)
			if healflowers ~= nil then
				healflowers.Transform:SetScale(.4,.4,0)
				healflowers.Transform:SetPosition(x - offset.x/2, 0, z - offset.z/2)
			end

            end
        end
    
    end)
end


function Super:Init()
	
		self:fishing(self.inst)
		self:picking(self.inst)
		self:choping(self.inst)
		
		self:goodman(self.inst)
		self:goodman2(self.inst)
		self:doubledrop(self.inst)
		self:fireflylight(self.inst)
		self:lifesteal(self.inst)
		self:buildmaster(self.inst)
		self:nanobots(self.inst)
		self:archmage(self.inst)
		self:cheatdeath(self.inst)
		self:refresh(self.inst)
		self:minemaster(self.inst)
		self:alltag(self.inst)
		
		self:electricattack(self.inst)
		self:freezeattack(self.inst)

		self:plantfriend(self.inst)		
end

return Super
