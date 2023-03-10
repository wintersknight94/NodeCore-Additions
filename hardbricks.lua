-- LUALOCALS < ---------------------------------------------------------
local ipairs, minetest, nodecore, pairs, type, math
    = ipairs, minetest, nodecore, pairs, type, math
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
for i = 1, 7 do
local o = (120 + (i * 20)) 
------------------------------------------------------------------------
local stonetile = nodecore.hard_stone_tile(i)
local bricktile = "nc_stonework_bricks.png^[opacity:" ..o
------------------------------------------------------------------------
	minetest.register_node(modname.. ":bricks_hard_stone_" ..i.. "_bonded", {
		description = "Stone Bricks",
		tiles = {"(" ..stonetile.. ")^(" ..bricktile.. ")"},
		groups = {
			stone = i + 1,
			rock = i,
			cracky = i + 2,
			stone_bricks = i + 2,
			hard_stone = i,
			hard_bricks = i
		},
		silktouch = false,
		crush_damage = 4,
		sounds = nodecore.sounds("nc_terrain_stony"),
		drop_in_place = modname .. ((i > 1)
			and (":bricks_hard_stone_" .. (i - 1) .. "_bonded") or ":bricks_stone_bonded"),
	})
end
------------------------------------------------------------------------
minetest.register_alias(modname .. ":bricks_stone_bonded", "nc_stonework:bricks_stone_bonded")
------------------------------------------------------------------------
-- Here's the node registry, Warr. Idk how to deal with your stone hardening abm.
-- I had my own simplified version but it wasn't consistent with vanilla stone hardening.
-- On top of that, my version caused abm bogging for some reason. Major fps drop.
-- I'm certain that you can do it both better and easier than I can. 
