local assets=
{ 
    Asset("ANIM", "anim/hat_wathgrithr.zip"),
}

local prefabs = 
{
}



local function onEquip(inst, owner, symbol_override)
    local fname = "hat_wathgrithr"
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, symbol_override or "swap_hat", inst.GUID, fname)
    else
        owner.AnimState:OverrideSymbol("swap_hat", fname, "swap_hat")
    end
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
end


local function onUnequip(inst, owner) 
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end


local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("hat_wathgrithr")
    anim:SetBuild("hat_wathgrithr")
    anim:PlayAnimation("idle")

    if not TheWorld.ismastersim then return inst end   
    inst.entity:SetPristine() 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"
	inst.components.inventoryitem.imagename = "wathgrithrhat"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onEquip)
    inst.components.equippable:SetOnUnequip(onUnequip)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY -- gain sanity

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED) -- cold proof

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL) -- water proof

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(750, 0.8)

    inst:AddComponent("inspectable")
    MakeHauntableLaunch(inst)

    return inst
end
return  Prefab("common/inventory/hatop", fn, assets, prefabs)
