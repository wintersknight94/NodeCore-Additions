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
	use_texture_alpha = "blend",
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
------------------------------------------------------------------------
local sapdef = {
	description = "Syrup",
	drawtype = "liquid",
	tiles = {saptxr},
	special_tiles = {saptxr, saptxr},
	use_texture_alpha = "blend",
	paramtype = "light",
	liquid_viscosity = 20,
	liquid_renewable = false,
	liquid_range = 1,
	walkable = false,
	buildable_to = false,
	drowning = 6,
	drop = "",
	groups = {
		syrup = 1,
		flammable = sapflam,
		concrete_wet = 1, -- A humorous afterthought, bonding bricks with syrup/sap
	},
	post_effect_color = {a = 225, r = 80, g = 60, b = 20},
	liquid_alternative_flowing = modname .. ":syrup_flowing",
	liquid_alternative_source = modname .. ":syrup_source",
	sounds = nodecore.sounds("nc_terrain_crunchy")
}
minetest.register_node(modname .. ":syrup_source",
	nodecore.underride({
		liquidtype = "source"
	}, sapdef))
minetest.register_node(modname .. ":syrup_flowing",
	nodecore.underride({
		liquidtype = "flowing",
		drawtype = "flowingliquid",
		paramtype2 = "flowingliquid"
	}, sapdef))
-- ================================================================== --
minetest.register_abm({ -- soaking abm or dnt might be better
	label = "syrup exuding",
	interval = 12,
	chance = 12,
	nodenames = {"nc_tree:root"},
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local above_node = minetest.get_node(above)
		if above_node.name == "air" then
			minetest.set_node(pos, {name = modname.. ":root_dry"})
			nodecore.item_eject(above, {name = modname .. ":syrup_source"})
		end
	end
})
-- ================================================================== --
minetest.register_abm({ -- might need to make this a dnt when i learn how dnts work
	label = "syrup congealing",
	interval = 120,
	chance = 2,
	nodenames = {"group:syrup"},
	action = function(pos, node)
		minetest.set_node(pos, {name = "air"})
		if math_random(1, 2) == 1 then return end
			nodecore.item_eject(pos, {name = sapball})
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
