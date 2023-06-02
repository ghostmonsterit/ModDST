local assets =
{
    Asset("ANIM", "anim/spear_wathgrithr.zip"),
    Asset("ANIM", "anim/swap_spear_wathgrithr.zip"),
}


local function Lifesteal(weapon_inst, attacker, target)
	if attacker.components.health ~= nil then
		attacker.components.health:DoDelta(1)
	end
	if attacker.components.sanity ~= nil then
		attacker.components.sanity:DoDelta(1)
	end
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_spear_wathgrithr", inst.GUID, "swap_spear_wathgrithr")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_spear_wathgrithr", "swap_spear_wathgrithr")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear_wathgrithr")
    inst.AnimState:SetBuild("swap_spear_wathgrithr")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.1, {0.7, 0.5, 0.7}, true, -9, {sym_build = "swap_spear_wathgrithr"})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE)
    inst.components.tool:SetAction(ACTIONS.CHOP)
    inst.components.tool:SetAction(ACTIONS.HAMMER)
    inst.components.tool:SetAction(ACTIONS.DIG)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(40)
	inst.components.weapon:SetOnAttack(Lifesteal)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.WATHGRITHR_SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.WATHGRITHR_SPEAR_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.finiteuses:SetConsumption(ACTIONS.PICK, 1)
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 5)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"
	inst.components.inventoryitem.imagename = "spear_wathgrithr"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("weaponop", fn, assets)
