/*
	------------------------------------------
	Script	:	SnapLoad - v1.7 (Macro)
	Date	:	Nov 2017
	------------------------------------------
	Notes	:	- Load previous take
				- Load previous version
				- Get info from file creation and extra notes if available
				- Archive
	
		Version updates:
			v1.5:	- Filename parsing changed to incorporate for project code prefix
					- Discipline abbreviation conversion in filename
			v1.6:	- Moved GetProjects and GetSubDirs functions to startUpLib
			v1.6.1:	- Bugfix: Properly browse through projects dirs, when new file
			v1.7:	- Opening a scene will create a local copy to work from
					- Option load either "version" or "take"
					- Code cleanup and optimisation
	
*/

(

global _snapLoad
global prjDirList = getdirectories (prjDir + "*")
global takeDir
global loadScene
global noteFile = ""
global noteFileContent = ""

-- fn GetProjects =
-- (
-- 	global projects = #()
-- 	for i in prjDirList do
-- 	(
-- 		local tmpPrj = substring i (prjDir.count + 1) ((i.count - 1) - prjDir.count)
-- 		append projects tmpPrj
-- 	)
-- )

-- fn GetSubDirs _root =
-- (
-- 	global subList = #()
-- 	subDir  = getdirectories (_root + @"\*")
-- 	
-- 	for i in subDir do
-- 	(
-- 		listItem = filterstring i @"\"
-- 		append subList listItem[listItem.count]	
-- 	)
-- )

fn VersionList _dir =
(
	global verList = #()
	files = getFiles (_dir + @"\*.max")
	for f in files do
	(
		listItems = filterstring f @"\"
		listItem = (filterstring listItems[listItems.count] ".")[1]
		appendIfUnique verList  (filterstring listItem "_")[6]		-- we might have multiple same version scenes according to component rendering
	)
)

fn TakeList _ver = 
(
	global takes = #()
	if takeDir == undefined then
		takeDir = getFiles (popPrjSel + @"shots" + _snapLoad._shot.selected + @"\" + GetDisCode(_snapLoad._dis.selected) + @"\" + _snapLoad._elm.selected + @"\snapshots\*.max")

	files = getFiles (takeDir + @"\*.max")
	for f in files do
	(
		listItems = filterstring f @"\"
		listItem = (filterstring listItems[listItems.count] ".")[1]
		if (filterstring listItem "_")[6] == _ver then
			append takes (filterstring listItem "_")[7]
	)
)

fn emptyList = subList.count == 0
	
fn populateEmpty _case =
(
	if _case == "shot" then
	(
		global popShotList = #("<empty>")
		global popDisList = #("<empty>")
	)
	global popElmList = #("<empty>")
	global popVerList = #("<000>")
	global popTakeList = #("<000>")
	global noteFileContent = ""
)

-- fn maxfileTake = (trimright noteFile "txt") + "max"

fn SceneFilename =
(
	return projectCode + "_" + _snapLoad._shot.selected + "_" + GetDisCode(_snapLoad._dis.selected) + "_" + _snapLoad._elm.selected + "_" + _snapLoad._ver.selected + ".max"
)

fn PopulateLists _prjSl _shotSl _disSl _elmSl _verSl _takeSl = 
(
	global popBitmap = prjDir + projects[_prjSl] + @"\" + projects[_prjSl] + ".png"	

	if not (doesfileexist popBitmap) then popBitmap = devDir + @"etc\emptyBMP.png"
	
	global popPrjSel = prjDirList[_prjSl]
	GetSubDirs (popPrjSel + @"shots")

	if emptyList() then 
		populateEmpty "shot"
	else
	(	
		global popShotList = subList
		GetSubDirs (popPrjSel + @"shots\" + popShotList[_shotSl])
		global popDisList = subList
		GetSubDirs (popPrjSel + @"shots\" + popShotList[_shotSl] + @"\" + popDisList[_disSl])

		if emptyList() then
			populateEmpty "elm"
		else
		(
			global popElmList = subList
			global verDir = popPrjSel + @"shots\" + popShotList[_shotSl] + @"\" + popDisList[_disSl] + @"\" + popElmList[_elmSl] + @"\"
			VersionList (verDir)
			global popVerList = sort verList

			global takeDir = popPrjSel + @"shots\" + popShotList[_shotSl] + @"\" + popDisList[_disSl] + @"\" + popElmList[_elmSl] + @"\snapshots\"
			TakeList popVerList[_verSl]
			global popTakeList = takes
			
			local foofile = (getfiles (takeDir + "*"))[1]
			foofile = (filterstring foofile @"\")[(filterstring foofile @"\").count]
			global projectCode = (filterstring foofile "_")[1]
			noteFile = takeDir + projectCode + "_" + popShotList[_shotSl] + "_" + getDisCode(popDisList[_disSl]) + "_" + popElmList[_elmSl] + "_" + popVerList[_verSl] + "_" + popTakeList[_takeSl] + ".txt"
			
			if doesFileExist noteFile then
			(
				local IOFile = dotNetClass "System.IO.File"
				noteFileContent = IOFile.ReadAllText noteFile
			)
			else
			(
-- 				local noteFilename = (filterstring noteFile @"\")[(filterstring noteFile @"\").count]
				local maxfileTake = (FilterString noteFile ".")[1] + ".max"
				noteFileContent = "Take file created on:\r\n" + getFileCreateDate maxfileTake
-- 				noteFileContent = "Take file created on:\r\n" + getFileCreateDate (takeDir + projects[4] + "_" + popShotList[1] + "_" + popDisList[1] + "_" + popElmList[1] + "_" + popVerList[1] + "_" + popTakeList[1] + ".max")
			)
		)
	)
)

RCmenu snapMenu
(
	subMenu "File"
	(
		menuItem m1_1 "Open Take Dir"
		menuItem m1_2 "Open Version Dir"
		separator sep1
		menuItem m1_3 "Exit"
	)
	
/*	subMenu "Extra"
	(
		menuItem m2_1 "Archive..."
	) */
	
	on m1_1 picked do
	(
		if _snapLoad._take.selected != "<000>" then
			showDir takeDir
		else
			messageBox("Not valid Take selected")
	)
	
	on m1_2 picked do 
	(
		if _snapLoad._ver.selected != "<000>" then
			showDir verDir
		else messageBox("Not valid Version selected")
	)
	
	on m1_3 picked do (destroyDialog _snapLoad)
)

rollout _snapLoad "Load Scene File" width:700 height:170
(
	dropdownList _prj "Projects" pos:[12,6] width:114 height:40 items:projects across:5	
	bitmap _bmp "Bitmap" pos:[13,46] width:112 height:112 filename:popBitmap
	listbox _shot "Shots" pos:[127,7] width:60 height:10 items:popShotList
	listbox _dis "Discipline" pos:[188,7] width:65 height:10 items:popDisList
	listbox _elm "Element" pos:[254,7] width:150 height:10 items:popElmList
	listbox _ver "Version" pos:[405,7] width:50 height:10 items:popVerList
	listbox _take "Take" pos:[456,7] width:50 height:10 items:popTakeList
	label _lblNotes "Notes" pos:[509,7]
	dotNetControl _notes "System.Windows.Forms.Textbox" width:187 height:88 pos:[508,23]
	button _btnOpen "Open Scene" pos:[535, 125] width:70 height:30
	button _btnCancel "Cancel" pos:[625, 125] height:30
	
	on _snapLoad open do
    (
        _notes.Font = dotNetObject "System.Drawing.Font" "MS Sans Serif" 8 ((dotNetClass "System.Drawing.FontStyle").Regular)
		_notes.BorderStyle = (dotNetClass "System.Windows.Forms.BorderStyle").FixedSingle
        _notes.BackColor = (dotNetClass "System.Drawing.Color").fromARGB (((colorMan.getColor #background) * 255)[1] as integer) (((colorMan.getColor #background) * 255)[2] as integer) (((colorMan.getColor #background) * 255)[3] as integer)
        _notes.ForeColor = (dotNetClass "System.Drawing.Color").fromARGB (((colorMan.getColor #text) * 255)[1] as integer) (((colorMan.getColor #text) * 255)[2] as integer) (((colorMan.getColor #text) * 255)[3] as integer)
		_notes.MultiLine = true
		_notes.WordWrap = true
-- 		_notes.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Vertical
		_notes.Text = noteFileContent
		_notes.ReadOnly = true
	)
	
	on _prj selected _prjIdx do
	(
		PopulateLists _prj.selection 1 1 1 1 1
		_bmp.filename = popBitmap
		_shot.items = popShotList
--		_shot.selection = 1
		_dis.items = popDisList
--		_dis.selection = 1
		_elm.items = popElmList
--		_elm.selection = 1
		_ver.items = popVerList
--		_ver.selection = 1
		_take.items = popTakeList
--		_take.selection = 1
		_notes.text = noteFileContent
	)
	
	on _shot selected _shotIdx do
	(
		PopulateLists _prj.selection _shot.selection 1 1 1 1
		_dis.items = popDisList
--		_dis.selection = 1
		_elm.items = popElmList
--		_elm.selection = 1
		_ver.items = popVerList
--		_ver.selection = 1
		_take.items = popTakeList
--		_take.selection = 1
		_notes.text = noteFileContent
	)
	
	on _dis selected _disIdx do
	(
		PopulateLists _prj.selection _shot.selection _dis.selection 1 1 1
		_elm.items = popElmList
--		_elm.selection = 1
		_ver.items = popVerList
--		_ver.selection = 1
		_take.items = popTakeList
--		_take.selection = 1
		_notes.text = noteFileContent
	)
	
	on _elm selected _elmIdx do
	(
		PopulateLists _prj.selection _shot.selection _dis.selection _elm.selection 1 1
		_ver.items = popVerList
--		_ver.selection = 1
		_take.items = popTakeList
--		_take.selection = 1
		_notes.text = noteFileContent
	)
	
	on _ver selected _verIdx do
	(
		PopulateLists _prj.selection _shot.selection _dis.selection _elm.selection _ver.selection 1
		_take.items = popTakeList
--		_take.selection = 1
		if _ver.selected != "<000>" then
		(
-- 			local sceneDir = prjDir + _prj.selected + @"\shots\" + _shot.selected + @"\" + _dis.selected + @"\" + _elm.selected + @"\"
-- 			local sceneFilePath = _prj.selected + "_" + _shot.selected + "_" + _dis.selected + "_" + _elm.selected + "_" + _ver.selected + ".max"
-- 			_notes.text = "Version last modified on:\r\n" + getFileModDate (sceneDir + sceneFilePath)
			local sceneFilePath = verDir + @"\" + projectCode + "_" + _shot.selected + "_" + GetDisCode(_dis.selected) + "_" + _elm.selected + "_" + _ver.selected + ".max"
			_notes.text = "Version last modified on:\r\n" + getFileModDate sceneFilePath
		)
	)
	
	on _take selected _takeIdx do
	(
		PopulateLists _prj.selection _shot.selection _dis.selection _elm.selection _ver.selection _take.selection
		_notes.text = noteFileContent
	)
	
	on _btnCancel pressed do 
		DestroyDialog _snapLoad
	
	on _ver doubleclicked _itm do
	(
		print("loading version...")
		loadScene("version")
	)
	
	on _take doubleclicked _itm do
	(
		loadScene("take")
	)
	
	on _btnOpen pressed do	--TODO:Better implementation. Load either version or take. Move the process in separate function that can be used by the menu items as well.
	(
		loadScene("take")
	)
	
	on _btnCancel pressed do
	(
		DestroyDialog _snapLoad
	)
)


fn loadScene sceneType = 
(
	dis_idx = findItem disGrp _snapLoad._dis.selected
	sceneName = _snapLoad._prj.selected + "_" + _snapLoad._shot.selected + "_" + disCode[dis_idx] + "_" + _snapLoad._elm.selected + "_" + _snapLoad._ver.selected
	scenePath = verDir + sceneName
	
	scenePartDir = _snapLoad._prj.selected + @"\" + _snapLoad._shot.selected + @"\" + disCode[dis_idx] + @"\" + _snapLoad._elm.selected + @"\" + _snapLoad._ver.selected + @"\"
	
	if sceneType == "take" then
	(
		sceneName += "_" + _snapLoad._take.selected
		scenePath = takeDir + sceneName
		scenePartDir += _snapLoad._take.selected + @"\"
	)
	
	scenePath += ".max"
	localSceneDir = workDir + scenePartDir
	localScenePath = localSceneDir + sceneName + ".max"
	print scenePath
	
	if CheckForSave() then
	(
		makeDir localSceneDir
		copyFile scenePath localScenePath
		if loadMaxFile localScenePath then
		(
			prjLib()
			DestroyDialog _snapLoad
		)
	)
)

fn loadSnapshot =
(
	if prjDirList.count == 0 then 
		messageBox ("Projects directory on " + prjDrv + " missing or unreachable...") title:"Error"
	else
	(
		-- initial population of GUI
		GetProjects prjDirList
		PopulateLists 1 1 1 1 1 1

		CreateDialog _snapLoad menu:snapMenu
	)
)


)