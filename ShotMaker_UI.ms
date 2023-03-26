/*
	-------------------------------------
	Script	:	Shot Maker v7.01 (Macro)
	Date	:	Aug 2016 (rev. Feb 2018)
	--------------------------------------
	Notes	:	Create a new scene 
	maxfile naming specifation : AA_001_001_fx_test_v001_t001.max
*/
(
	

-- Include Libraries / Files --------------------------------------------
scaleGuyAsset = devDir + @"etc\ScaleGuy_Asset.max"
vraySunSetup = devDir + @"etc\VRaySun_Setup01.max"
------------------------------------------------------------------------------
	
-- initialise variables
prIndex = 1
disIndex = 5
seqNum = "Seq #"
shotNum = "000"
element = "element"
shotDirList = #()
project = ""
flag = 0

-- declare rollout names
global _newShot
global _selShot
global _createSeq

-- short for start/end animation frames in integer format
fstart = animationrange.start as integer / ticksperframe
fend = animationrange.end as integer / ticksperframe

prjDirList = getdirectories (prjDir + "*")

if prjDirList.count == 0 then 
	messageBox ("No actual projects found on " + prjDir + "\n or location is unreachable...") title:"Error"
else
(
	systemUnits = #(#("in", #inches), #("ft", #feet), #("mi", #miles), #("mm", #millimeters), #("cm", #centimeters), #("m", #meters), #("km", #kilometers))
	fps = #(#("Film", 24), #("PAL", 25), #("NTSC", 30), #("Current", frameRate), #("Custom", ""))
	res = #(#("1080p", 1920, 1080), #("720p", 1280, 720), #("Custom", "", ""), #("Current", renderWidth, renderHeight))

	tempNotesFile = #()
	for i = 1 to prjDirList.count do
		tempNotesFile[i] = getFiles (prjDirList[i] + "*.txt")

	notesFile = #()
	for j = 1 to tempNotesFile.count do
	(
		if tempNotesFile[j][1] == undefined then tempNotesFile[j][1] = (prjDirList[j] + "--.txt")
		notesFile[j] = tempNotesFile[j][1]
	)

	prjNameList = #()
	prjCodeList = #()
	temp = #()
	for k = 1 to prjDirList.count do
	(
		prjNameList[k] = substring prjDirList[k] (prjDir.count + 1) (prjDirList[k].count - (prjDir.count + 1))
		
		temp = (filterstring notesfile[k] "\ .")
		prjCodeList[k] = temp[(temp.count - 1)]
	)

	-- Check if a valid filename is used and pre-load its project data into the "New Shot" dialog
	-- makes it easy to quickly create a variation of the existing scene
	if validName() != false then
	(
		mfnInfo = filterstring maxfilename "_"
		prIndex = findItem prjCodeList mfnInfo[1]
		disIndex = findItem disCode mfnInfo[4]
		seqNum = mfnInfo[2]
		shotNum = mfnInfo[3]
		element = mfnInfo[5]
	)

	-- function that loads the existing shots for the selected project
	list1 = #()
	list2 = #()

	fn GetShots _selectedSeq =
	(
		local tmpShotList = #()
		shotArray = #(#(),#())
		seqList = shotArray[1]
		numList = shotArray[2]

		for i = 1 to shotDirList.count do
		(	
			tmpShotList[i] = tmpSL = filterstring shotDirList[i] @"\"
			tmpShotList[i] = tmpSL[tmpSL.count]
			for j = 1 to 2 do
				shotArray[j][i] = (filterstring tmpShotList[i] "_")[j]
		)

		list1 = #()
		list2 = #()

		for i = 1 to seqList.count do
			appendIfUnique list1 seqList[i]

		if _selectedSeq == "" then
			for i = 1 to numlist.count do
				if seqList[i] == amin seqList do append list2 numlist[i] 
		else
			for i = 1 to numlist.count do
				if seqlist[i] == _selectedSeq then append list2 numlist[i]
	)

	rollout _createSeq "Create Shot"
	(
		edittext _prjLabel "Project" height:17 readonly:true bold:true width:150 pos:[91,8] --align:#center
		edittext _newSeqInput "Seq #" text:"000" width:70 align:#right across:2 
		edittext _newShotInput "  Num #" text:"000" width:80 
		button _ok "Ok" width:55 height:21 across:2
		button _cancel "Cancel" width:55 height:21 
		
		on _ok pressed do
		(
			_newShot._seqInput.text = _newSeqInput.text
			_newShot._shotInput.text = _newShotInput.text
			_createSeq.open = false
			_newShot.open = true
			_selShot.open = false
		)
		
		on _cancel pressed do
		(
			case flag of 
			(
				1:	_newShot.open = true
				2:	_selShot.open = true
			)
			_createSeq.open = false
		)
	)

	rollout _selShot "Select Shot"
	(
		listbox _seqList "Seq." across:2
		listbox _numList "Num." 
		checkbox _anotherShot "Create new" align:#center
		button _ok "Ok!" width:55 height:21 across:2
		button _cancel "Cancel" width:55 height:21
		
		on _seqList selected _newSeq do
		(
			GetShots _seqList.selected
			_numList.items = sort list2
		)		
		
		on _ok pressed do
		(
			if _anotherShot.checked then 
			(
				flag = 2
				_createSeq.open = true
				_createSeq._newSeqInput.text = _seqList.selected
				_createSeq._prjLabel.text = project
				_anotherShot.checked = false
			)
			else
			(
				_newShot._seqInput.text = _seqList.selected
				_newShot._shotInput.text = _numList.selected
				_selShot.open = false
				_newShot.open = true
			)
		)
		
		on _cancel pressed do
		(
			_selShot.open = false
			_newShot.open = true
			_seqList.selection = finditem list1 _newShot._seqInput.text
			_numList.selection = finditem list2 _newShot._shotInput.text
		)
	)

	rollout _newShot "Shot Set-Up" width:340 height:350
	(
		groupBox _grpPrj "Project" pos:[13,8] width:154 height:65
		label _lblPrjName "Name" pos:[29,28] width:28 height:13 across:2
		dropdownList _prjName pos:[63,26] width:95 height:21 items:prjNameList selection:prIndex
		label _lblPrjCode "Code" pos:[30,51] width:25 height:13 across:2
		edittext _prjCode text:prjCodeList[_prjName.selection] pos:[60,50] width:96 height:13 

		groupBox _grpShot "Shot" pos:[13,77] width:154 height:183
		button _seqInput seqNum pos:[22,96] width:65 height:17 across:2 
		edittext _shotInput "Num #" text:shotNum pos:[90,96] width:66 height:17
		listbox _disInput "Discipline" pos:[22,118] width:136 height:7 items:disGrp selection:disIndex 
		edittext _elmInput "Element" text:element pos:[22,237] width:136 height:17
		
		groupbox _specs "Scene details" pos:[175,8] width:143 height:252
		label _anm "Animation:" pos:[190, 27]
		spinner _anmStart "Start" type:#integer range:[-1000, 10000, fstart] pos:[238,45] width:67 
		spinner _anmEnd "End" type:#integer range:[-1000, 10000, fend] pos:[239,66] width:66 

		label _reslbl "Output Size" pos:[190, 90] 
		dropdownlist _res items:(for i in res collect i[1]) pos:[246, 89] width:65
		edittext _resWidth pos:[200, 114] width:45 text:(res[_res.selection][2] as string) enabled:false
		label _x "x" pos:[248, 114]	
		edittext _resHeight pos:[253, 114] width:45 text:(res[_res.selection][3] as string) enabled:false
	-- 	radiobuttons _res labels:#("1080p", "720p", "Custom") pos:[195,105] columns:1
	-- 	edittext _resCust pos:[252, 133] width:40 text:"1080" enabled:false

		label _fpslbl "Framerate" pos:[190, 138]
		dropdownlist _fps width:65 pos:[245, 137] items:(for i in fps collect i[1]) selection:1
		edittext _fpsRate width:41 pos:[200,160] text:(fps[_fps.selection][2] as string) enabled:false across:2
		label _lblfps "fps" pos:[246,161]
		
		label _sulbl "System Units:" pos:[185, 187] 
		dropdownlist _su width:44 pos:[257, 181] items:(for i in systemUnits collect i[1]) selection:5
		
		label _xtra "___________________" pos:[190, 200]
		checkbox _vray "V-Ray" pos:[185, 222] checked:true
		checkbox _gi "GI" pos:[240, 222] checked:false
		checkbox _linear "Linear" pos:[185, 240] checked:true
		checkbox _scaleguy "ScaleGuy" pos:[240, 240] checked:false
		
		radiobuttons _sceneType pos:[120, 267] labels:#("Current scene", "New empty scene") default:2 columns:1

		button _createShot "--> Create Shot <--" height:30 pos:[116, 305]
		
		on _newShot open do
			project = _prjName.selected

		on _prjName selected i do 
		(
			project = _prjName.selected
			_prjCode.text = prjCodeList[i]
			_seqInput.text = "Seq #"
			_shotInput.text = "000"
			
		)
		
		on _seqInput pressed do
		(
			shotDirList = getdirectories (prjDir + project + @"\shots\*")
			if shotDirList.count == 0 then
			(
				flag = 1
				_createSeq._prjLabel.text = project
				_createSeq.open = true
				_newShot.open = false
				_selShot.open = false
			)
			else
			(
				if _seqInput.text != seqNum then
					GetShots _seqInput.text
				else
				(
					GetShots ""
					_selShot._seqList.selection = 1
					_selShot._numList.selection = 1
				)
				
				_newShot.open = false
				_selShot.open = true
				_selShot._seqList.items = sort list1
				_selShot._numList.items = sort list2
			)
		)
		
	-- 	Resolution Changes
		on _res selected _selectRes do 
			case _res.selection of
			(
				3: (
						_resWidth.enabled = true 
						_resHeight.enabled = true
					)
				default: (
								_resWidth.text = (res[_res.selection][2] as string)
								_resHeight.text = (res[_res.selection][3] as string)
								_resWidth.enabled = false
								_resHeight.enabled = false
							)		
			)
			
	--	Frame Rate Changes
		on _fps selected _selectFPS do
			case _fps.selection of
			(
				5: (
						_fpsRate.enabled = true
					)
				default: (
								_fpsRate.text = (fps[_fps.selection][2] as string)
								_fpsRate.enabled = false
							)
			)
			
	--	Scene Type Changes
		on _sceneType changed state do
			if _sceneType.state == 1 then 
			(
				_anmStart.value = fstart
				_anmEnd.value = fend
				_res.selection = 4
				_resWidth.text = (res[_res.selection][2] as string)
				_resHeight.text = (res[_res.selection][3] as string)
				_fps.selection = 4
				_fpsRate.text = (fps[_fps.selection][2] as string)
				idx = 1
				while (findItem systemUnits[idx] units.SystemType) == 0 do
					idx += 1
				_su.selected = systemUnits[idx][1]
				_vray.checked = false
	--			_vray.enabled = false
				_gi.checked = false
	--			_gi.enabled = false
				_linear.checked = false
	--			_linear.enabled = false
				_scaleguy.checked = false
	--			_scaleguy.enabled = false
			)
		
		on _createShot pressed do
		(
			if _prjCode.text == "empty" then
				messageBox "Selected project directory is empty\nCreate one first or choose another from the list" title:"Invalid project dir"
			else
			(
				if _elmInput.text == "" then
				(
					messageBox "Element value cannot be blank !" title:"Error"
				)
				else
				(
					local valid = true
					for i = 1 to _elmInput.text.count do
					(
						if _elmInput.text[i] == "_" or _prjName.text[i] == "." then 
						(
							MessageBox "Invalid element character '_' or '.'"
							valid = false
						)
					)
					if valid == true then
					( 
						if _sceneType.state == 2 then 
						(
							if getSaveRequired() then 
							(
								if queryBox "Do you want to save your current scene?" then (getSaveFileName caption:"Saving current scene...")
							)
						)
						prjName = project
						prjCode = _prjCode.text
						seqNum = _seqInput.text
						shotNum = _shotInput.text
						shot = seqNum + "_" + shotNum
						shotCode = prjCode + "_" + seqNum + "_" + shotNum
						dis = disCode[_disInput.selection]
						elm = _elmInput.text
						
						prjPath = prjDir + prjName + @"\"
						
						-- max file name
						mfn = shotCode + "_" + dis + "_" + elm + "_v001"

						-- snapshot filename
						mfnSnap = mfn + "_t001"
						
						-- max file path
						mfp = prjPath + @"shots\" + shot + @"\" + _disInput.selected + @"\" + elm + @"\"
						
						-- snapshot path
						mfpSnap = mfp + @"snapshots\"
						
						fileOutPath = mfp + mfn
						fileOutPathSnap = mfpSnap + mfnSnap
						rendOutPath = rendDir + prjName + @"\" + shot + @"\" + _disInput.selected + @"\" + elm + @"\" + @"v001\"
						ro = rendOutPath + mfn + ".exr"

						-- confirmations
						if querybox ("New shot: " + mfn + "\n\nProceed with shot creation?") title:"Shot creation" then
						(
							if (not (doesfileexist (FileOutPath + ".max"))) or querybox ("filename: "+ mfn + ".max already exists.\nOverwrite?") then
							(
								-- check first if need to reset scene
								if _sceneType.state == 2 then (resetMaxFile #noPrompt)
								
								-- apply the scene detail settings --
								-- set the animation range
								animationrange = interval _anmStart.value _anmEnd.value
								
								-- set resolution
								renderscenedialog.close()	
								renderWidth = (_resWidth.text as integer)
								renderHeight = (_resHeight.text as integer)
						
								-- set framerate
								framerate = (_fpsRate.text as integer)
								
								-- set system units
								units.SystemType = systemUnits[_su.selection][2]
								
								-- extra checkboxes
								if _vray.checked then 
								(
									vr = renderers.current = VRay()
									vr.imageSampler_type = 1				-- adaptive
									vr.system_vrayLog_show = 3			-- show log only on error
								)
								
								if _linear.checked and _vray.checked then
								(
									IDisplayGamma.colorCorrectionMode = #gamma
									IDisplayGamma.gamma = 2.2
									vr.colorMapping_type = 6
									vr.colorMapping_darkMult = 1
									vr.colorMapping_brightMult = 1
								)
								
								if _gi.checked and _vray.checked then
								(
									vr.gi_on = true
									vr.gi_primary_type = 0			-- irradiance map
									vr.gi_secondary_type = 3		-- light cache
									vr.gi_irradmap_preset = 1		-- very low
									vr.gi_ao_on = true				-- enable ambient occlusion
									vr.gi_ao_amount = 1.2
									
									mergemaxfile vraySunSetup #autorenameDups #useSceneMtlDups #select		-- insert a light setup file
									mySky = VRaySky()
									meditmaterials[1] = environmentmap = mysky
								)
								
								if _scaleGuy.checked then
								(
									mergemaxfile scaleGuyAsset #autorenameDups #useSceneMtlDups #select
									$.name = uniquename "ScaleGuy_001"
								)

								-- create shot directory structure
								for disDir in disGrp do
									makedir (prjPath + @"shots\" + shot + @"\" + disDir)
								
								makedir mfpSnap
								
								RRepath rendOutPath ro
								savemaxfile fileOutPath
								savemaxfile fileOutPathSnap useNewFile:false
								
								closeRolloutFloater shotMaker 
							)
						)
					)
				)
			)
		)
	)

	shotMaker = newRolloutFloater "Shot Maker" 335 415

	fn shotsMaker =
	(
		addRollout _newShot shotMaker 
		addRollout _selShot shotMaker rolledup:true
		addrollout _createSeq shotMaker rolledup:true
	)
)

)