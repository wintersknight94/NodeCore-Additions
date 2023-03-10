-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, pairs, vector
    = minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
local carpetdirs = {
	{x = 1, y = 0, z = 0},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z = -1}
}
local carpetwet = modname .. ":carpet_wet"
------------------------------------------------------------------------
local function findwater(pos)
	return nodecore.find_nodes_around(pos, "group:water")
end

local function soakup(pos)
	local any
	for _, p in pairs(findwater(pos)) do
		nodecore.node_sound(p, "dig")
		minetest.remove_node(p)
		any = true
	end
	return any
end
------------------------------------------------------------------------
minetest.register_abm({
		label = "carpet wet",
		interval = 1,
		chance = 10,
		nodenames = {modname .. ":carpet"},
		neighbors = {"group:water"},
		action = function(pos)
			if soakup(pos) then
				nodecore.set_loud(pos, {name = modname .. ":carpet_wet"})
				return nodecore.fallcheck(pos)
			end
		end
	})

nodecore.register_aism({
		label = "carpet stack wet",
		interval = 1,
		chance = 10,
		itemnames = {modname .. ":carpet"},
		action = function(stack, data)
			if data.pos and soakup(data.pos) then
				local taken = stack:take_item(1)
				taken:set_name(modname .. ":carpet_wet")
				if data.inv then taken = data.inv:add_item("main", taken) end
				if not taken:is_empty() then nodecore.item_eject(data.pos, taken) end
				return stack
			end
		end
	})

minetest.register_abm({
		label = "carpet sun dry",
		interval = 1,
		chance = 100,
		nodenames = {modname .. ":carpet_wet"},
		arealoaded = 1,
		action = function(pos)
			local above = {x = pos.x, y = pos.y + 1, z = pos.z}
			if nodecore.is_full_sun(above) and #findwater(pos) < 1 then
				nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = pos})
				return minetest.set_node(pos, {name = modname .. ":carpet"})
			end
		end
	})

nodecore.register_aism({
		label = "carpet stack sun dry",
		interval = 1,
		chance = 100,
		arealoaded = 1,
		itemnames = {modname .. ":carpet_wet"},
		action = function(stack, data)
			if data.player and (data.list ~= "main"
				or data.slot ~= data.player:get_wield_index()) then return end
			if data.pos and nodecore.is_full_sun(data.pos)
			and #findwater(data.pos) < 1 then
				nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = data.pos})
				local taken = stack:take_item(1)
				taken:set_name(modname .. ":carpet")
				if data.inv then taken = data.inv:add_item("main", taken) end
				if not taken:is_empty() then nodecore.item_eject(data.pos, taken) end
				return stack
			end
		end
	})

minetest.register_abm({
		label = "carpet fire dry",
		interval = 1,
		chance = 20,
		nodenames = {modname .. ":carpet_wet"},
		neighbors = {"group:igniter"},
		action = function(pos)
			nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = pos})
			return minetest.set_node(pos, {name = modname .. ":carpet"})
		end
	})
------------------------------------------------------------------------
nodecore.register_craft({
		label = "squeeze carpet",
		action = "pummel",
		toolgroups = {thumpy = 1},
		indexkeys = {carpetwet},
		nodes = {
			{
				match = carpetwet
			}
		},
		after = function(pos)
			local found
			for _, d in pairs(carpetdirs) do
				local p = vector.add(pos, d)
				if nodecore.artificial_water(p, {
						matchpos = pos,
						match = spongewet,
						minttl = 1,
						maxttl = 10
					}) then found = true end
			end
			if found then nodecore.node_sound(pos, "dig") end
		end
	})

