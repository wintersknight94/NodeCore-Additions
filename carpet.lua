-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, string, vector
    = minetest, nodecore, string, vector
local string_gsub
    = string.gsub
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
-- ================================================================== --
-- <><><><> Slice (Menger) Sponges into (Sierpinski) Carpets <><><><> --
-- ================================================================== --
minetest.register_node(modname .. ":carpet", {
	description = "Carpet",
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	node_box = nodecore.fixedbox({-0.5, -15/32, -0.5, 0.5, -14/32, 0.5}),
	tiles = {"nc_sponge.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	floodable = false,
	groups = {
		snappy = 1,
		flammable = 3,
		fire_fuel = 3,
		carpet = 1
	},
	air_pass = true,
	sounds = nodecore.sounds("nc_terrain_swishy"),
	on_place = minetest.rotate_node
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":carpet_wet", {
	description = "Wet Carpet",
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	node_box = nodecore.fixedbox({-0.5, -15/32, -0.5, 0.5, -14/32, 0.5}),
	tiles = {"nc_sponge.png^(nc_terrain_water.png^[opacity:96)"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	floodable = false,
	groups = {
		snappy = 1,
		coolant = 1,
		moist = 1,
		carpet = 1
	},
	sounds = nodecore.sounds("nc_terrain_swishy"),
	on_place = minetest.rotate_node
})
------------------------------------------------------------------------
-- To me it makes the most sense to get 16 carpets per sponge, but that seemed
-- a bit op, so I only made it 8 until testing shows it should be more/less.
-- It could just as well be 6, given that a cube has 6 faces, and a sierpinski carpet
-- is a 2d plane, rather than an actual carpet, but whatever. 
------------------------------------------------------------------------
nodecore.register_craft({
	label = "slice sponge into carpet",
	action = "pummel",
	indexkeys = {"nc_sponge:sponge"},
	nodes = {
		{match = "nc_sponge:sponge", replace = "air"}
	},
	items = {
		{name = modname.. ":carpet", count = 8, scatter = 4},
	},
	toolgroups = {choppy = 3},
	itemscatter = 4
})
nodecore.register_craft({
	label = "slice wet sponge into wet carpet",
	action = "pummel",
	indexkeys = {"nc_sponge:sponge_wet"},
	nodes = {
		{match = "nc_sponge:sponge_wet", replace = "air"}
	},
	items = {
		{name = modname.. ":carpet_wet", count = 8, scatter = 4},
	},
	toolgroups = {choppy = 3},
	itemscatter = 4
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "compress carpets back to sponges",
	action = "pummel",
	toolgroups = {thumpy = 1},
	indexkeys = {modname .. ":carpet"},
	nodes = {
		{
			match = {name = modname .. ":carpet", count = 8},
			replace = "nc_sponge:sponge"
		}
	}
})
