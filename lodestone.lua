-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
minetest.register_ore({
		name = "nc_lode:cobble",
		ore_type = "scatter",
		ore = "nc_lode:cobble",
		wherein = "nc_lode:stone",
		random_factor = 0,
		noise_params = {
			offset = 0,
			scale = 4,
			spread = {x = 32, y = 12, z = 32},
			seed = 23565,
			octaves = 3,
			persist = 0.5,
			flags = "eased",
		},
		noise_threshold = 0.5,
		y_max = 600,
		y_min = -600,
		clust_num_ores = 1,
		clust_size = 1,
		clust_scarcity = 8 * 8 * 8 * 4
	})
------------------------------------------------------------------------
-- Doesn't make sense to find partially dug ore buried in solid stone
-- so only caves are worth searching as it must be exposed to air
------------------------------------------------------------------------
local c_lode = minetest.get_content_id("nc_lode:cobble")
local c_lodestone = minetest.get_content_id("nc_lode:stone")
local c_air = minetest.get_content_id("air")

nodecore.register_mapgen_shared({
		label = "lode cobble exposure",
		func = function(minp, maxp, area, data)
			local ai = area.index
			for z = minp.z, maxp.z do
				for y = minp.y, maxp.y do
					local offs = ai(area, 0, y, z)
					for x = minp.x, maxp.x do
						local i = offs + x
						if data[i] == c_lode then
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
							then data[i] = c_lodestone
						end
					end
				end
			end
		end
	end
})

