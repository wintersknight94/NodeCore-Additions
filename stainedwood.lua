-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()

local plank = modname .. ":plank"

local rfcall = function(pos, data)
	local ref = minetest.get_player_by_name(data.pname)
	local wield = ref:get_wielded_item()
	wield:take_item(1)
	ref:set_wielded_item(wield)
end

minetest.register_node(plank, {
		description = "Stained Wooden Plank",
		tiles = {"nc_woodwork_plank.png^[colorize:#704214:100"}, --Sepia
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
				{match = "nc_woodwork:plank", replace = modname .. ":plank"}
			}
	})
