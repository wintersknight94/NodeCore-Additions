 -- LUALOCALS < ---------------------------------------------------------
local include, minetest, nodecore
    = include, minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
-- ================================================================== --

include("popeggcorn")

------------------------------------------------------------------------

include("carpet")
if minetest.settings:get_bool(modname .. ".sierpinski", true) then
	include("sierpinski")
end

------------------------------------------------------------------------

if minetest.settings:get_bool(modname .. ".syrup", true) then
	include("syrup")
	else include("treesap")
end
include("torch")
include("stainedwood")

------------------------------------------------------------------------

include("lodestone")
include("glowstone")

------------------------------------------------------------------------

include("moredoor")

------------------------------------------------------------------------

include("hardbricks")

------------------------------------------------------------------------

include("reinforced")

