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
local balltxr = saptxr.. "^[mask:nc_fire_lump.png"
local sapflam = 60	-- Seems ok for now, will likely adjust after researching chemical properties of various tree saps.
local suff = "_glued"
-- ================================================================== --
--minetest.register_craftitem(sapball, {
--	description = "Resin", --"Sap Lump",
--	inventory_image = saptxr.. "^[mask:nc_fire_lump.png",
--	groups = {
--		sap = 1,
--		flammable = sapflam
--	},
--	sounds = nodecore.sounds("nc_terrain_crunchy")
--})
minetest.register_node(sapball, {
	description = "Resin",
	drawtype = "nodebox",
	tiles = {saptxr},
	inventory_image = balltxr,
	wield_image = balltxr,
--	wield_scale = {x = 1.25, y = 1.25, z = 1.75},
	paramtype = "light",
	node_box = {
	type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.1875, 0.125, -0.4375, 0.1875}, -- NodeBox1
			{-0.1875, -0.5, -0.125, 0.1875, -0.4375, 0.125}, -- NodeBox2
		}
	},
	sunlight_propagates = true,
	walkable = true,
	floodable = true,
	groups = {
		snappy = 1,
		sap = 1,
		flammable = sapflam,
		stack_as_node = 1,
--		falling_node = 1
	},
	sounds = nodecore.sounds("nc_terrain_crunchy"),
	selection_box = nodecore.fixedbox({-3/8, -1/2, -3/8, 3/8, 1/4, 3/8}),
	drop = sapball,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node
})
-- ================================================================== --
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
	interval = 120,
	chance = 20,
	nodenames = {"nc_tree:root"},
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local above_node = minetest.get_node(above)
		if above_node.name == "air" then
			minetest.set_node(above, {name = sapball})
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
-- ================================================================== --
minetest.register_alias(modname.. ":syrup_source",		sapball)
minetest.register_alias(modname.. ":syrup_flowing",		sapball)
-- ================================================================== --
