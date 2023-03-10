-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
minetest.register_ore({
		name = "nc_lux:cobble",
		ore_type = "scatter",
		ore = "nc_lux:cobble1",
		wherein = "nc_terrain:stone",
		random_factor = 0,
		noise_params = {
			offset = 0,
			scale = 3,
			spread = {x = 32, y = 12, z = 32},
			seed = 782917,
			octaves = 3,
			persist = 0.5,
			flags = "eased",
		},
		noise_threshold = 1.2,
		y_max = -40,
		y_min = -31000,
		clust_num_ores = 1,
		clust_size = 1,
		clust_scarcity = 16 * 16 * 16 * 8
	})
------------------------------------------------------------------------
-- Doesn't make sense to find partially dug ore buried in solid stone
-- so only caves are worth searching as it must be exposed to air
------------------------------------------------------------------------
local c_lux = minetest.get_content_id("nc_lux:cobble1")
local c_glowstone = minetest.get_content_id("nc_terrain:stone")
local c_air = minetest.get_content_id("air")

nodecore.register_mapgen_shared({
		label = "lux cobble exposure",
		func = function(minp, maxp, area, data)
			local ai = area.index
			for z = minp.z, maxp.z do
				for y = minp.y, maxp.y do
					local offs = ai(area, 0, y, z)
					for x = minp.x, maxp.x do
						local i = offs + x
						if data[i] == c_lux then
							if x == minp.x
							or x == maxp.x
							or y == minp.y
							or y == maxp.y
							or z == minp.z
							or z == maxp.z
							or (data[i - 1] ~= c_air
								and data[i + 1] ~= c_air
								and data[i - area.ystride] ~= c_air
								and data[i + area.ystride] ~= c_air
								and data[i - area.zstride] ~= c_air
								and data[i + area.zstride] ~= c_air)
							then data[i] = c_glowstone
						end
					end
				end
			end
		end
	end
})

