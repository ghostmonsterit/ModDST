local _G = GLOBAL

AddRecipe("hatop", {Ingredient("wathgrithrhat",1), Ingredient("goldnugget",1)}, 
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater", "images/inventoryimages.xml", "wathgrithrhat.tex")
_G.STRINGS.NAMES.HATOP= "Siêu Giáp mũ"  
_G.STRINGS.RECIPE_DESC.HATOP = "Giáp mũ bảo vệ đầu của bạn！" 
_G.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HATOP = "Hãy mặc giáp mũ để bảo vệ đầu của bạn"

AddRecipe("armorop",{Ingredient("armorwood", 1),Ingredient("goldnugget", 1)},
_G.RECIPETABS.SURVIVAL,  _G.TECH.NONE, nil, nil, nil, nil, "cheater", "images/inventoryimages1.xml","armor_bramble.tex")
_G.STRINGS.NAMES.ARMOROP= " Siêu Giáp"   
_G.STRINGS.RECIPE_DESC.ARMOROP = "Giáp bảo vệ cơ thể của bạn！"
_G.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOROP = "Hãy mặc giáp để bảo vệ cơ thể của bạn"

-- AddRecipe("moltendarts",{Ingredient("livinglog", 1),Ingredient("rope", 1),Ingredient("stinger", 1)},
-- _G.RECIPETABS.SURVIVAL,  _G.TECH.NONE, nil, nil, nil, nil, "cheater", "images/inventoryimages1.xml","blowdart_lava2.tex")
-- _G.STRINGS.NAMES.MOLTENDARTS= " Siêu ống thổi"   
-- _G.STRINGS.RECIPE_DESC.MOLTENDARTS = "Chiến đấu với siêu ống thổi của bạn！"
-- _G.STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOLTENDARTS = "Pew ! Pew ! Pew !"

AddRecipe("rocks", {Ingredient("flint", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")


AddRecipe("weaponop",{Ingredient("spear_wathgrithr", 1),Ingredient("goldnugget", 1)},
_G.RECIPETABS.SURVIVAL,  _G.TECH.NONE, nil, nil, nil, nil, "cheater", "images/inventoryimages.xml","spear_wathgrithr.tex")
_G.STRINGS.NAMES.WEAPONOP= "Siêu giáo chiến"
_G.STRINGS.RECIPE_DESC.WEAPONOP = "Chiến đấu với siêu giáo chiến của bạn！"
_G.STRINGS.CHARACTERS.GENERIC.DESCRIBE.WEAPONOP = "Chiến! chiến! chiến!"


AddRecipe("compostwrap", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("lucy", {Ingredient("axe", 1),Ingredient("nightmarefuel", 2),Ingredient(_G.CHARACTER_INGREDIENT.HEALTH, 50)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("antlionhat", {Ingredient("wathgrithrhat", 1),Ingredient("nightmarefuel", 5),Ingredient("goldenpitchfork", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("beardhair", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("skeleton", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("mermthrone", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("pigtorch", {Ingredient("petals", 10)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("waterplant_bomb", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")

--seeds
AddRecipe("carrot_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("corn_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("dragonfruit_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("durian_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("eggplant_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("pomegranate_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("pumpkin_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("watermelon_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("asparagus_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("tomato_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("potato_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("onion_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("pepper_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("garlic_seeds", {Ingredient("seeds", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
--resource
AddRecipe("rook", {Ingredient("gear", 1),Ingredient("nightmarefuel",2),Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 20)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")

AddRecipe("fossil_piece", {Ingredient("boneshard", 2),Ingredient("nightmarefuel",1),Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 10)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")

--foot
AddRecipe("drumstick", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("meat", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("fishmeat", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("wobster_sheller_land", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("barnacle", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("pondeel", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("butter", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("goatmilk", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("tallbirdegg", {Ingredient("petals", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")

--Staff
AddRecipe("opalstaff", {Ingredient("livinglog", 2), Ingredient("nightmarefuel", 4), Ingredient("opalpreciousgem", 1)}, 
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil,"cheater")
_G.STRINGS.NAMES.MACHETE2= "Trượng gọi sao băng" 
_G.STRINGS.RECIPE_DESC.MACHETE2 = "Từ phép thuật cổ xưa gọi ngay một sao băng làm giảm nhiệt độ xung quanh bạn！" 


AddRecipe("yellowstaff", {Ingredient("livinglog", 2), Ingredient("nightmarefuel", 4), Ingredient("yellowmooneye", 1)}, 
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil,"cheater")
_G.STRINGS.NAMES.MACHETE2= "Trượng gọi sao hỏa"   
_G.STRINGS.RECIPE_DESC.MACHETE2 = "Từ phép thuật cổ xưa gọi ngay một sao hỏa làm tănh nhiệt độ xung quanh bạn！"  


AddRecipe("opalpreciousgem", {Ingredient("redgem", 3), Ingredient("greengem", 3), Ingredient("bluegem", 3)}, 
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil,"cheater")
_G.STRINGS.NAMES.OPALPRECIOUSGEM = "Đá quý ánh kim"  
_G.STRINGS.RECIPE_DESC.OPALPRECIOUSGEM = "Nó lấp lánh và mê hoặc giống như một ngọn lửa！" 

--Add For All
AddRecipe("krampus_sack", {Ingredient("goldnugget", 40) , Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 75) , Ingredient("nightmarefuel", 6)},
GLOBAL.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater") -- balo krampus_sack
AddRecipe("butterfly", {Ingredient("petals", 1) , Ingredient("butterflywings", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("bundle", {Ingredient("papyrus", 4) , Ingredient("rope", 1)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("redpouch", {Ingredient("goldnugget", 2)},
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")

--Hermit

AddRecipe("shadowlumber_builder",  {Ingredient("nightmarefuel", 2), Ingredient("axe", 1)},  
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("shadowminer_builder",   {Ingredient("nightmarefuel", 2), Ingredient("pickaxe", 1)},   
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, nil, nil, "cheater")
AddRecipe("shadowdigger_builder",  {Ingredient("nightmarefuel", 2), Ingredient("shovel", 1)},  
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, true, nil, "cheater")
AddRecipe("shadowduelist_builder", {Ingredient("nightmarefuel", 2), Ingredient("spear", 1)}, 
_G.RECIPETABS.SURVIVAL, _G.TECH.NONE, nil, nil, true, nil, "cheater")