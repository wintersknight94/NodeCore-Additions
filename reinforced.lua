-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, pairs, vector
    = minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
local glare = "nc_optics_glass_glare.png"
local edges = "nc_optics_glass_edges.png"
local clear = glare.. "^" ..edges
local alode = "nc_lode_annealed.png"
local tlode = "nc_lode_tempered.png"
local lmesh = alode.. "^[mask:nc_concrete_pattern_hashy.png"
local frame = alode.. "^[mask:nc_api_storebox_frame.png"
------------------------------------------------------------------------
local rglass = glare.. "^" ..lmesh
local rgedge = frame.. "^" ..edges
------------------------------------------------------------------------
local src = "nc_optics:glass_hot_source"
local flow = "nc_optics:glass_hot_flowing"
------------------------------------------------------------------------
local function near(pos, crit)
	return #nodecore.find_nodes_around(pos, crit, {1, 1, 1}, {1, 0, 1}) > 0
end
-- ================================================================== --
minetest.register_node(modname .. ":glass_hard", {
	description = "Reinforced Glass",
	drawtype = "glasslike_framed",
	tiles = {
		"(" ..rglass.. ")^(" ..rgedge.. ")",
		rglass
	},
	groups = {
		silica = 1,
		silica_reinforced = 1,
		cracky = 4,
		lux_absorb = 20,
		scaling_time = 300
	},
	sunlight_propagates = true,
	paramtype = "light",
	sounds = nodecore.sounds("nc_optics_glassy")
})
-- ================================================================== --
nodecore.register_craft({
	label = "cool reinforced glass",
	action = "cook",
	duration = 120,
	touchgroups = {flame = 0},
	neargroups = {coolant = 0},
	cookfx = {smoke = true, hiss = true},
	check = function(pos)
		return not near(pos, {flow})
	end,
	indexkeys = {src},
	nodes = {
		{
			match = src,
			replace = "air"
		},
		{
			y = -1,
			match = "nc_lode:frame_annealed",
			replace = modname .. ":glass_hard"
		}
	}
})
-- ================================================================== --
nodecore.register_craft({
		label = "hammer reinforced glass to crude",
		action = "pummel",
		priority = -1,
		toolgroups = {thumpy = 5},
		nodes = {
			{
				match = {groups = {silica_reinforced = true, visinv = false}},
				replace = "nc_lode:form"
			}
		},
		items = {"nc_optics:glass_crude"}
	})
-- ================================================================== --
