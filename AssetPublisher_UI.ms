/*
	------------------------------------------
	Script	:	Asset Publisher - v2.1
	Date	:	Aug 2015 (rev May 2018)
	------------------------------------------
	Notes	:	directory structure:
				shot/asset/<assset_name>/
											 /archive/
		asset categories
						- camera
						- layout
						- fx
						- character
						- vehicle
	
		filename format: 	shotCode_ASSET-assetCategory-assetName-Master.max				NO!
		archive format : 	shotCode_ASSET-assetCategory-assetName[timestamp].max			NO!
*/
(

--		Include Libraries / Files		--

------------------------------------------

rollout _assetPub "Asset Publisher"
(
	dropdownlist _assetType items:assetType
	edittext _assetName "Asset: "
	listbox _pubAssets "Published Assets" items:(SortAssets _assetType.selected)
	button _goPub "Publish"
	
	on _assetType selected _at do 
		_pubAssets.items = SortAssets _assetType.selected
	
	on _pubAssets doubleclicked _pa do
		_assetName.text = _pubAssets.selected
	
	on _pubAssets rightclick _paIdx do
		ShowDir (assetsDir + _assetType.selected + @"\" + _pubAssets.selected)
	
	on _goPub pressed do
	(
		
		if _assetName.text != "" then
		(
-- 				assetPath = assetsDir + _assetType.selected + @"\" + _assetName.text + @"\"
			assetPath = assetLibDir + _assetType.selected + @"\" + _assetName.text + @"\"
-- 				assetFile = shotCode + "_ASSET-" + _assetType.selected + "-" + _assetName.text + "-Master"
			assetFile = "FXS_Asset_" + _assetName.text + "_pub"
			markerFilename = "FXS_Asset_" + _assetName.text + "_marker"
			assetFileOut = assetPath + assetFile + ".max"
			scriptFileOut = assetPath + assetFile + ".ms"
			markerFileOut = assetPath + markerFilename + ".ms"
			assetArchive = assetPath + @"archive\"

			makedir assetArchive

			if doesFileExist assetFileOut then 
			(
				messageBox ("Asset file already exists.\nCurrent version will be auto-archived.") title:"Publish"
				DateTime (getFileModDate assetFileOut)
-- 					newFileOut = shotCode + "_ASSET-" + _assetType.selected + "-" + _assetName.text + "[" + timestring + "].max"
				newFileOut = _assetName.text + "[" + timestring + "].max"
				renameFile assetFileOut (assetArchive + newFileOut)
			)
			saveMaxFile assetFileOut
			
			markerFile = createFile markerFileOut
			format "%\n" ("mergeMaxFile @\"" + assetFileOut + " #autorenameDups #useSceneMtlDups #select #alwaysReparent\"") to:markerFile
			format "%\n" ("filein @\"" + scriptFileOut + "\"") to:markerFile
			close markerFile
			
			-- Update GUI
			CollectAssets()
			_pubAssets.items = SortAssets _assetType.selected
		)
		else
			MessageBox "Please enter a valid asset name." title:"Publish"

	)
)

CollectAssets()

createdialog _assetPub


)
