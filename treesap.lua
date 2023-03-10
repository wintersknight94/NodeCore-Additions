-- LUALOCALS < ---------------------------------------------------------
local math, minetest, nodecore, pairs, string, type 
    = math, minetest, nodecore, pairs, string, type
local math_random
    = math.random
local string_sub
    = string.sub
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local saptxr = modname.. "_sap.png"
local sapball = modname .. ":lump_sap"
local sapflam = 60	-- Seems ok for now, will likely adjust after researching chemical properties of various tree saps.
local suff = "_glued"
-- ================================================================== --
minetest.register_craftitem(sapball, {
	description = "Resin", --"Sap Lump",
	inventory_image = saptxr.. "^[mask:nc_fire_lump.png",
	groups = {
		sap = 1,
		flammable = sapflam
	},
	sounds = nodecore.sounds("nc_terrain_crunchy")
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":root_dry",
	nodecore.underride({
		tiles = {
			"nc_tree_tree_top.png^[colorize:tan:25",
			"nc_terrain_dirt.png",
			"nc_terrain_dirt.png^(nc_tree_roots.png^[colorize:tan:25)"
		}
	}, minetest.registered_items["nc_tree:root"])
)
-- ================================================================== --
minetest.register_abm({ -- soaking abm or dnt might be better
	label = "sap exuding",
	interval = 60,
	chance = 20,
	nodenames = {"nc_tree:root"},
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local above_node = minetest.get_node(above)
		if above_node.name == "air" then
			nodecore.item_eject(above, {name = sapball})
		if math_random(1, 2) == 1 then return end
			minetest.set_node(pos, {name = modname.. ":root_dry"})
		end
	end
})
-- ================================================================== --
nodecore.register_craft({
		label = "glue optic",
		action = "pummel",
		wield = {name = sapball},
		consumewield = 1,
		indexkeys = "group:optic_gluable",
		duration = 2,
		nodes = {{
				match = {groups = {optic_gluable = true}}, stacked = false
		}},
		after = function(pos, data)
			data.node.name = data.node.name .. suff
			return minetest.swap_node(pos, data.node)
		end
	})
