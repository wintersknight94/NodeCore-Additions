-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, pairs, vector
    = minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local popcorn = "nc_woodwork_plank.png^(nc_fire_ash.png^[mask:nc_concrete_mask.png)"
-- ================================================================== --
-- I don't even like popcorn ya'll, it hurts my teeth! -- Wintersknight94
-- ================================================================== --
minetest.register_node(modname .. ":cornplank", {
	description = "Popeggcorn",
	tiles = {popcorn},
	groups = {
		choppy = 1,
		flammable = 2, -- be careful, as you can easily burn your popeggcorn after it pops!
		fire_fuel = 2,
		falling_node = 1
	},
	sounds = nodecore.sounds("nc_tree_corny"), 
	visinv_bulk_optimize = true
})
------------------------------------------------------------------------
-- This allows eggcorns to be used in a cook recipe while still allowing you to 'burn the popcorn'
minetest.override_item("nc_tree:eggcorn",
	{groups = {flammable = 20}}
)
------------------------------------------------------------------------
local function findheat(pos)
	return nodecore.find_nodes_around(pos, "group:damage_radiant")
end
-- gentle application of heat is important --
nodecore.register_aism({ 
	label = "pop eggcorns",
	interval = 4,
	chance = 4,
	arealoaded = 1,
	itemnames = {"nc_tree:eggcorn"},
	action = function(stack, data)
		if #findheat(data.pos) > 1 then
			nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = data.pos})
			local taken = stack:take_item(1)
			taken:set_name(modname .. ":cornplank")
			if data.inv then taken = data.inv:add_item("main", taken) end
			if not taken:is_empty() then nodecore.item_eject(data.pos, taken) end
			return stack
		end
	end
})
