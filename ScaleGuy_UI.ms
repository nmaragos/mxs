/*

		ScaleGuy
		
*/

(
	

scaleGuyAsset = devDir + @"etc\ScaleGuy_Asset.max"

fn ImportScaleGuy =
(
	mergemaxfile scaleGuyAsset #autorenameDups #useSceneMtlDups #select
	$.name = uniquename "ScaleGuy_001"
)

	
)