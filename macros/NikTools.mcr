-- Place file in C:\Users\<user>\AppData\Local\Autodesk\3ds Max\<ver>-64bit\ENU\usermacros

(

	macroscript prjDirGenMacro category:"NikTools" tooltip:"ProjectGen"
	(
		global prjDirGen
		global shotMaker
		filein (devDir + "ProjectDirGen_UI.ms")
		on execute do prjDirGen()
	)

	macroscript shotMakerMacro category:"NikTools" tooltip:"ShotMaker"
	(
		global shotsMaker
		on execute do 
		(
			filein (devDir + "ShotMaker_UI.ms")
			shotsMaker()
		)
	)
	
	macroscript scaleGuyMacro category:"NikTools" tooltip:"ScaleGuy"
	(
		global ImportScaleGuy
		filein (devDir + "ScaleGuy_UI.ms")
		on execute do ImportScaleGuy()
	)
	
	macroscript quickGIMacro category:"NikTools" tooltip:"QuickGI"
	(
		global SetGI
		filein (devDir + "QuickGI_UI.ms")
		on execute do SetGI()
	)
	
	macroscript versionUpMacro category:"NikTools" tooltip:"VersionUp"
	(
		global version
		on execute do 
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "VersionUp_UI.ms")
				version()
			)
			else
				errorMsg "filename"
	)

	macroscript snapShotMacro category:"NikTools" tooltip:"Snapshot"
	(
		on execute do 
--			if ValidName() == "ValidVersion" then
			if ValidName() != false then
			(
				prjLib()
				filein (devDir + "SnapShot_UI_v2.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript snap2verMacro category:"NikTools" tooltip:"SnapToVer"
	(
		global Snap2Ver
		on execute do 
			(
				if ValidName() != false then 
					prjLib()
				filein (devDir + "SnapToVersion_UI.ms")
				Snap2Ver()
			)
	)
	
	macroscript snapLoad category:"NikTools" tooltip:"SnapLoad"
	(
		global loadSnapshot
		on execute do
		(
			if ValidName() != false then
				prjLib()
			filein (devDir + "SnapLoad.ms")
			loadSnapShot()
		)
	)
	
	macroscript publishSceneMacro category:"NikTools" tooltip:"PublishScene"
	(
		on execute do 
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "PublishScene_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript assetPublisherMacro category:"NikTools" tooltip:"PublishAsset"
	(
		on execute do 
		(
			prjLIb()
			filein (libDir + "assetsLib.ms")
			filein (devDir + "AssetPublisher_UI.ms")
		)
	)
	
	macroscript assetImporterMacro category:"NikTools" tooltip:"ImportAsset"
	(
		on execute do 
		(
			prjLIb()
			filein (libDir + "assetsLib.ms")
			filein (devDir + "AssetImporter_UI.ms")
		)
	)
	
	macroscript addRenderElementsMacro category:"NikTools" tooltip:"RenderElements"
	(
		on execute do
			if ValidName() != false then
			(
				prjLib()
				filein (libDir + "RenderElementsLib.ms")
				filein (devDir + "AddRenderElements_UI.ms")
			)
			else
				errorMsg "filename"
	)

	macroscript noHoldOutPassMacro category:"NikTools" tooltip:"NoHoldOutPass"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "noHoldoutPass_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript RGBLightPassMacro category:"NikTools" tooltip:"RGBLightPass"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "RGBLightPass_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript ShadowPassMacro category:"NikTools" tooltip:"ShadowPass"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "ShadowPass_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript ILPMacro category:"NikTools" tooltip:"Interactive Lighting Pass"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				try (destroydialog _ilp) catch()
				prjLib()
				filein (devDir + "ILP_UI.ms")
			)
			else
				errorMsg "filename"
		
	)
	
	macroscript ILPDLMacro category:"NikTools" tooltip:"Interactive Lighting Pass (Deadline)"
	(
		global DLSubmit
		on execute do
			if ValidName() == "ValidVersion" then
			(
				try (destroydialog _ilp) catch()
				prjLib()
				filein (libDir + "DLLib.ms")
				filein (devDir + "ILP-DLSubmit_UI.ms")
			)
			else
				errorMsg "filename"
		
	)
	
	macroscript TestRenderMacro category:"NikTools" tooltip:"TestRender"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "TestRender_UI_v2.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript FFXRepathMacro category:"NikTools" tooltip:"FFXRepath"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				try (destroydialog _ffxRepath) catch()
				filein (devDir + "FFXRepath_v5.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript FFXLockMacro category:"NikTools" tooltip:"FFXLock"
	(
		global FFXLock
		on execute do
		(
			try (destroydialog _gridLock) catch()
			filein (devDir + "FFXGridLock_UI.ms")
			FFXLock()
		)
	)
	
	macroscript TPRepathMacro category:"NikTools" tooltip:"TPRepath"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				try (destroydialog _tpCacheRepath) catch()
				filein (devDir + "TPSetCache_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript PlayBlastMacro category:"NikTools" tooltip:"Playblast"
	(
		on execute do
			if ValidName() != false then
			(
				try (destroydialog _ffxPlayBlast) catch()
				prjLib()
				filein (libDir + "PbLib.ms")
				filein (devDir + "Playblast_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript BBSubmitMacro category:"NikTools" tooltip:"BBSubmit"
	(
		global BBSubmit
		on execute do
			if ValidName() == "ValidVersion" then
			(
				try (closeRolloutFloater submitJob) catch()
				prjLib()
				filein (libDir + "BBLib.ms")
				filein (libDir + "RenderElementsLib.ms")
				filein (devDir + "BBSubmit_UI_v5.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript DLSubmitMacro category:"NikTools" tooltip:"DLSubmit"
	(
		global DLSubmit
		on execute do
			if ValidName() == "ValidVersion" then
			(
				try (closeRolloutFloater submitJob) catch()
				prjLib()
				filein (libDir + "DLLib.ms")
				filein (libDir + "RenderElementsLib.ms")
				filein (devDir + "DLSubmit_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript BBRetrieveMacro category:"NikTools" tooltip:"BBRetrieve"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				try (destroydialog _bbDB) catch()
				prjLib()
				filein (libDir + "BBLib.ms")
				filein (devDir + "BBRetrieve_UI.ms")
			)
			else
				errorMsg "filename"
	)
	
	macroscript DailiesMacro category:"NikTools" tooltip:"Dailies"
	(
		global Reviews
		on execute do
		(
			try (destroydialog _rReview) catch()
			filein (devDir + "DailiesReview_UI.ms")
			Reviews()
		)
	)
	
	macroscript PflowCacheMacro category:"NikTools" tooltip:"PflowCache"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "PflowCache_UI.ms")
			)
	)
	
	macroscript PflowSubElemRenderMacro category:"NikTools" tooltip:"PflowRender"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				try (destroydialog _rendRange) catch()
				prjLib()
				filein (devDir + "PflowSubElemRender_UI.ms")
			)
	)
	
	macroscript QuickRenderRepathMacro category:"NikTools" tooltip:"RenderRepath"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				prjLib()
				filein (devDir + "QuickRenderRepath_UI.ms")
			)
			else errorMsg "filename"
	)
	
	macroscript QTnZipOutMacro category:"NikTools" tooltip:"QTnZipOut"
	(
		on execute do
			if ValidName() == "ValidVersion" then
			(
				try (destroydialog _QTnZip) catch()
				try (destroydialog _getAddress) catch()
				prjLib()
				filein (libDir + "nukeLib.ms")
				filein (libDir + "mailLib.ms")
				filein (devDir + "QTnZipOut_UI.ms")
			)
			else errorMsg "filename"
	)
	
	macroscript DevTools category:"NikTools" toolTip:"DevTools"
	(
		on execute do
			filein(devDir + "devTools.ms")
	)
	
	
)