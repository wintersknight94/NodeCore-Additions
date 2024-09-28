-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
-- <>==============================================================<> --
minetest.register_node(modname.. ":sapnode", {
	description = "Resin",
	tiles = {modname.. "_sap.png"},
--	use_texture_alpha = "blend",		--enabling this causes weird xray veiwing through the node
	groups = {
		crumbly = 2,
		flammable = 2,
		fire_fuel = 8,
		sapnode = 1
	},
	sounds = nodecore.sounds("nc_terrain_crunchy")
})
-- <>==============================================================<> --
nodecore.register_craft({
	label = "break sapnode to lumps",
	action = "pummel",
	indexkeys = {"group:sapnode"},
	nodes = {{match = {groups = {sapnode = true}}, replace = "air"}},
	items = {{name = modname .. ":lump_sap", count = 8, scatter = 5}},
	toolgroups = {crumbly = 2},
	itemscatter = 5
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "pack sap lumps",
	action = "pummel",
	toolgroups = {thumpy = 2},
	indexkeys = {modname .. ":lump_sap"},
	nodes = {
		{
			match = {name = modname .. ":lump_sap", count = 8},
			replace = modname.. ":sapnode"
		}
	}
})
-- <>==============================================================<> --
