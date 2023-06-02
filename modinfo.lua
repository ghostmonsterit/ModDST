--[[	Copyright © 2015 Ultroman	 ]]
name = "Mod Null"
description = "Allows you to set the base rate of hunger.\nRanges are: 400-200% loss in increments of 25, and 200% loss to 200% gain in increments of 5%.\nShould be compatible with mods that change the time-settings, which factors into the calculation of the hunger-rate."
author = "GhostMonster_it"
version = "0.0.0.4"

forumthread = ""

api_version = 6
dst_api_version = 10 -- line added for forum thread; is not like this in mod currently

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true

all_clients_require_mod = false
client_only_mod = false

server_filter_tags = {"vn", "gmit", "vietnam", "tryhard"}

priority = 0

icon_atlas = "modicon.xml"
icon = "modicon.tex"

local valuelist = {}
for i = 0, 255 do
    valuelist[i] = {description = i, data = i}
end

local function AddTitle(title)
    return {
        label = title,
        name = "",
        hover = "",
        options = {{description = "", data = 0}},
        default = 0
    }
end
-- This is a shortened version of the configuration_options available in the mod. There are 4 times as many in the actual mod.
configuration_options =
{
	AddTitle("General"),
    {
        name = "language",
        hover = "Chọn ngôn ngữ\nChoose your language",
        label = "Ngôn ngữ",
        options =
        {
            {description = "VietNam", data = "vietnam", hover = "VietNam"},
            {description = "English", data = "english", hover = "English"},
        },
        default = "auto",
    },
	AddTitle("Options"),
	{
		name = "Mod options name",
		label = "Mod options label %",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = true,
	}
}