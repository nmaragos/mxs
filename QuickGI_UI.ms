(

	
-- light setup file
vraySunSetup = devDir + @"etc\VRaySun_Setup01.max"

fn SetGI =
(
	-- switch to VRay
	vr = renderers.current = VRay()
	vr.imageSampler_type = 1				-- adaptive subdiv
	vr.system_vrayLog_show = 3			-- show log only on error

	-- enable GI & settings
	vr.gi_on = true
	vr.gi_primary_type = 0			-- irradiance map
	vr.gi_secondary_type = 3		-- light cache
	vr.gi_irradmap_preset = 1		-- very low
	vr.gi_ao_on = true				-- enable ambient occlusion
	vr.gi_ao_amount = 1.2

	-- merge light setup 
	mergemaxfile vraySunSetup #autorenameDups #useSceneMtlDups #select
	mySky = VRaySky()
	meditmaterials[1] = environmentmap = mysky
)


)