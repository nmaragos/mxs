/*
	------------------------------------------
	Script	:	Asset Importer - v2.1
	Date	:	Aug 2015 (rev. May 2018)
	------------------------------------------
	Notes	:	- scan through assets dir of current shot
				- list assets in categories
				- load selected asset
				- to do : snapshot of imported asset
*/
(

global importAssetFileIn
	
rollout _assetImport "Asset Import" width:200 height:180
(
	listbox _assetType items:assetType across:2
	listbox _pubAssets items:(SortAssets _assetType.selected)
	button _openDir "Open Asset Dir" height:25
	
	on _assetType selected _at do
		_pubAssets.items = SortAssets _assetType.selected
	
	on _pubAssets doubleclicked _pa do
	(
		ImportAsset _assetType.selected _pubAssets.selected
		destroyDialog _assetImport
	)
	
	on _openDir pressed do
	(
		if _pubAssets.selected == undefined then showDir (assetLibDir + _assetType.selected)
		else 
		(
			importAssetDir = assetLibDir + _assetType.selected + @"\" + _pubAssets.selected
			showDir importAssetDir
		)
	)
)

CollectAssets()

createDialog _assetImport

)
