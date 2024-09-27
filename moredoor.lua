-- LUALOCALS < ---------------------------------------------------------
local ItemStack, minetest, nodecore, pairs, vector
    = ItemStack, minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()

-- ================================================================== --
-- <> One Does Not Simply Walk Into Moredoor <> --
-- ================================================================== --

nodecore.register_door(modname, "cornplank", "Popped", "nc_woodwork:staff", 1)
nodecore.register_door(modname, "plank", "Stained Wood", "nc_woodwork:staff", 1)
nodecore.register_door("nc_flora", "thatch", "Rattan", "nc_woodwork:staff", 1)
--nodecore.register_door("nc_flora", "wicker", "Wicker", "nc_woodwork:staff", 1)
--nodecore.register_door("nc_optics", "glass", "Glass", "nc_lode:rod_tempered", 3)
--nodecore.register_door("nc_optics", "glass_float", "Clear", "nc_lode:rod_tempered", 3)
nodecore.register_door("nc_optics", "glass_opaque", "Chromatic", "nc_lode:rod_tempered", 3)
nodecore.register_door("nc_lode", "block_annealed", "Lode", "nc_lode:rod_tempered", 5)



-- ================================================================== --
-- <> One Does Not Simply Walk Into Moredoor <> -- 
-- ================================================================== --

-- I see what the problem with adding allfaces and allfaces_optional doortypes is now.
-- Even the overrides with alpha blending seem broken due to MT rendering issues.

--minetest.override_item(modname.. ":panel_wicker",{drawtype = "normal", use_texture_alpha = true,})
--minetest.override_item(modname.. ":door_wicker",{drawtype = "normal", use_texture_alpha = true,})

--minetest.override_item(modname.. ":panel_glass",{drawtype = "normal", use_texture_alpha = true,})
--minetest.override_item(modname.. ":door_glass",{drawtype = "normal", use_texture_alpha = true,})

--minetest.override_item(modname.. ":panel_glass_float",{drawtype = "normal", use_texture_alpha = true,})
--minetest.override_item(modname.. ":door_glass_float",{drawtype = "normal", use_texture_alpha = true,})

-- ================================================================== --
-- <> One Does Not Simply Walk Into Moredoor <> -- Never gets old --
-- ================================================================== --

minetest.register_alias(modname.. ":panel_cornplank",				"nc_doors:panel_cornplank")
minetest.register_alias(modname.. ":door_cornplank",				"nc_doors:door_cornplank")

minetest.register_alias(modname.. ":panel_thatch",				"nc_doors:panel_thatch")
minetest.register_alias(modname.. ":door_thatch",				"nc_doors:door_thatch")

minetest.register_alias(modname.. ":panel_glass_opaque",				"nc_doors:panel_glass_opaque")
minetest.register_alias(modname.. ":door_glass_opaque",				"nc_doors:door_glass_opaque")

minetest.register_alias(modname.. ":panel_block_annealed",				"nc_doors:panel_block_annealed")
minetest.register_alias(modname.. ":door_block_annealed",				"nc_doors:door_block_annealed")