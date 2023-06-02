_G = GLOBAL

GLOBAL.DEPLOYSPACING.MIN = 6
GLOBAL.DEPLOYSPACING_RADIUS[GLOBAL.DEPLOYSPACING.MIN] = .5

AddPrefabPostInit("butterfly", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)


--
AddPrefabPostInit("marblebean",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("acorn",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("pinecone",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("twiggy_nut",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)


AddPrefabPostInit("butterfly", function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("dug_berrybush",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("dug_berrybush2",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("dug_berrybush_juicy",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("dug_sapling",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("dug_marsh_bush",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

AddPrefabPostInit("dug_grass",
function(inst)
    if GLOBAL.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(GLOBAL.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(GLOBAL.DEPLOYSPACING.MIN)
	end
end)

-- If it doesn't make sense for something to block placement, it shouldn't do so.

local jerks = { -- prefabs go here
    "dmgind",
    "coldfire",
    "campfire",
    "succulent_potted",
    "pottedfern",
    "ruinsrelic_plate",
    "ruinsrelic_chipbowl",
    "balloon",
    "minisign",
    "houndfire",
    "tornado",
    "tumbleweed",
}

local tags = {
    "bird",
    "animal",
    "insect",
    "character",
    "smallcreature",
    "largecreature",
    "small_livestock",
    "projectile",
    "pollinator",
    "monster",
    "hostile",
    "stalkerbloom",
    "_follower",
    "_inventoryitem",
}

local function IsInTable(e,t)
    local r = false
    for a,b in pairs(t) do if e.prefab == b then r = true end end
    return r
end

local function IsMine(e)
    return e:HasTag("mine") or e:HasTag("trap")
end

local function DeployCheck(e)
    if e:HasTag("mineactive") then e:RemoveTag("noblock") elseif not e:HasTag("noblock") then e:AddTag("noblock") end
end

local function Check(e)
    if IsMine(e) then e:DoPeriodicTask(0.5,DeployCheck) end
    if IsInTable(e,jerks) then e:AddTag("NOBLOCK") end
    for a,b in pairs(tags) do
        if e:HasTag(b) then
            e:AddTag("NOBLOCK")
        end
    end
end

AddPrefabPostInitAny(Check)

--


for _,v in pairs(GLOBAL.AllRecipes) do v.min_spacing = 1 end


--
local function change_transplantfn_no_fertilize (inst)
  if inst.components.pickable ~= nil then
    inst.components.pickable.ontransplantfn = function (inst2)
      inst2.components.pickable:MakeEmpty()
      inst2.components.pickable.transplanted = false
    end
  end
end

local noFertilize = GetModConfigData("NOFERTILIZE")

if noFertilize then
  AddPrefabPostInitAny (change_transplantfn_no_fertilize)
end
