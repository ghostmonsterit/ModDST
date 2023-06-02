local _G = GLOBAL

	--modimport("scripts/stogareupdate.lua")
	modimport("scripts/update.lua")
	modimport("scripts/commands.lua")	
	modimport("scripts/recipes.lua")	
	modimport("scripts/hotkey.lua")	
	modimport("scripts/pet.lua")
	modimport("scripts/nopacing.lua")

-- if _G.TheNet and ((_G.TheNet:GetIsServer() and _G.TheNet:GetServerIsDedicated()) or (_G.TheNet:GetIsClient() and not _G.TheNet:GetIsServerAdmin()) or TheNet:GetServerIsClientHosted()) then
	-- return
-- end



PrefabFiles = 
{
"weaponop",
"armorop",
"hatop",

"fernsfx",
"healflowersfx",
}
--KU_6BQkk1qw
if GLOBAL.TheNet:GetUserID() == "KU_6BQkk1qw" or GLOBAL.TheNet:GetUserID() == "OU_76561199160362194" then
	
	
	AddPlayerPostInit(function(inst) 
		inst:AddTag("cheater")
		inst:AddComponent("super")
		if not GLOBAL.TheNet:GetIsClient() then
			inst.components.super:Init()
		end

		inst:AddTag("masterchef")
		inst:AddTag("professionalchef")
		inst:AddTag("expertchef")
		inst:AddTag("storyteller")
		inst:AddTag("slingshot_sharpshooter")

		inst:AddTag("reader")
		inst:AddTag("shadowmagic")

		inst:AddComponent("reader")
		inst:AddComponent("petleash")
        inst.components.petleash:SetMaxPets(5)

		inst:AddTag("fastpicker")
		inst:AddTag("woodcutter")
		inst:AddTag("fastbuilder")

	end)
end


-- if _G.TheNet and ((_G.TheNet:GetIsServer() and _G.TheNet:GetServerIsDedicated()) or (_G.TheNet:GetIsClient() and not _G.TheNet:GetIsServerAdmin())) then
	-- return
-- end
