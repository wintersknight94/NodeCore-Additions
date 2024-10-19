-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math
    = minetest, nodecore, math
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local rfcall = function(pos, data)
	local ref = minetest.get_player_by_name(data.pname)
	local wield = ref:get_wielded_item()
	wield:take_item(1)
	ref:set_wielded_item(wield)
end

local wood = "nc_woodwork_plank.png"
local resin = modname.. "_sap.png"

for i = 1,6 do
 local stup = i+1
 local black = i*32
 local plank = modname .. ":plank_stained_" ..i
 local stain = "(" ..resin.. "^[opacity:140)^[colorize:black:" ..black

	minetest.register_node(plank, {
		description = "Stained Wooden Plank",
	--	tiles = {"nc_woodwork_plank.png^[colorize:#704214:100"}, --Sepia
		tiles = {wood.. "^(" ..stain.. ")"},
		groups = {
			choppy = 1,
			flammable = 1,
			fire_fuel = 5,
			nc_door_scuff_opacity = 72
		},
		sounds = nodecore.sounds("nc_tree_woody")
	})

	local function bashrecipe(thumpy, normaly)
		nodecore.register_craft({
			label = "bash stained planks to sticks",
			action = "pummel",
			toolgroups = {thumpy = thumpy},
			normal = {y = normaly},
			indexkeys = {plank},
			nodes = {
				{match = plank, replace = "air"}
			},
			items = {
				{name = "nc_tree:stick 2", count = 4, scatter = 5}
			}
		})
	end
	bashrecipe(3, 1)
	bashrecipe(5, -1)

	nodecore.register_craft({
		label = "stain wood planks",
		action = "pummel",
		wield = {name = modname.. ":lump_sap"},
		after = rfcall,
		nodes = {
				{match = "nc_woodwork:plank", replace = modname.. ":plank_stained_1"}
			}
	})

	if i <= 5 then
		nodecore.register_craft({
			label = "stain wood planks",
			action = "pummel",
			wield = {name = modname.. ":lump_sap"},
			after = rfcall,
			nodes = {
					{match = modname.. ":plank_stained_" ..i, replace = modname.. ":plank_stained_" ..stup}
				}
		})
	end
	
	nodecore.register_craft({
		label = "scrape stain from planks",
		action = "pummel",
		duration = stup,
		toolgroups = {choppy = 4},
		indexkeys = {plank},
		nodes = {
			{match = plank, replace = "nc_woodwork:plank"}
		}
	})
end
minetest.register_alias(modname .. ":plank",				modname .. ":plank_stained_1")
minetest.register_alias(modname.. ":plank_stained",			modname.. ":plank_stained_1")