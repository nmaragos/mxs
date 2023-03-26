/*
	------------------------------------------
	Script	:	DevTools - v1.0
	Date	:	Aug 2018
	------------------------------------------
	Notes	:	Quick tools for dev use
	
		Version updates:
			
*/

(
try (destroyDialog _commonTools) catch()

startUpArray = #("TD_StartUpLib", "TD_StudioLib")
libArray = getfiles (libDir + "*.ms")

libArrayName = #()

for _itm in libArray do
(
	libName = substring _itm (libDir.count + 1) (_itm.count - libDir.count - 3)
	append libArrayName libName
)

rollout _commonTools "Common Tools" (
	listbox _strtScripts "StartUp Scripts" items:startUpArray height:7 width:125 selection:0 across:2
	listbox _libs "Lib files" items:libArrayName height:7 width:125 selection:0 align:#right
	group "Common Paths" (
		button _dev "mxsDevPath" height:25 across:3
		button _mfp "MaxFilePath" width:76 height:25
		button _prj "ProjectPath" width:73 height:25
		button _nikTools "NikTools.mcr" width:76 height:25 across:3 toolTip:"Click to run. Right-click to edit"
		button _cache "Caches" width:76 height:25
		button _rend "RenderPath" width:73 height:25
	)
	group "Template Files" (
		button _psd1 "Edit/Create Project Icon" width:146 
		button _psd "Open Project Icon Template" width:146 
		button _nuke "Open Nuke Template" width:146
		button _xml "Open Dir Structure Template" width:146
	)
	group "External Programs" (
		button _openNuke "Nuke" across:3
		button _openPhotoshop "Photoshop"
		button _openNotepad "Notepad"
	)
	
	on _strtScripts doubleClicked _itm do
	(
		local scriptFile = (GetDir #maxroot) + @"stdplugs\stdscripts\" + startUpArray[_itm] + ".ms"
		edit scriptFile
	)
	
	on _strtScripts selected _foo do
		_libs.selection = 0 
	
	on _libs selected _foo do
		_strtScripts.selection = 0
	
	on _libs doubleClicked _itm do
		edit libArray[_itm]
	
	on _libs rightClick _itm do
	(
		_strtScripts.selection = 0
		_libs.selection = _itm
		str = "filein (libDir +\"" + libArrayName[_itm] + ".ms\")"
		CopyTextToClipboard str
	)
	
	on _NikTools rightClick do
	(
		local scriptFile = devDir + @"macros\NikTools.mcr"
		if doesFileExist(scriptFile) then
			edit scriptFile
		else
			messageBox("File " + scriptFile + " not found")
	)
	
	on _NikTools pressed do
		fileIn (devDir + @"macros\NikTools.mcr")
	
	on _mfp pressed do
		if maxfilepath != "" then
			ShowDir maxfilepath
	
	on _prj pressed do
		if prjPath == undefined then
			ShowDir prjDir
		else
			ShowDir prjPath

	on _cache pressed do
		if ValidName() !=false then
		(
			prjLib() 
			if not ShowDir (cacheDir + curPrj + @"\" + shotNum) then
				messageBox "Directory not found."
		)
		else
			ShowDir cacheDir
	
	on _rend pressed do
		if ValidName() != false then
		(
			prjLib() 
			if not ShowDir (rendDir + curPrj + @"\" + shotNum + @"\" + (GetDis dis) + @"\" + elm + @"\" + ver) then 
				messageBox "Directory not found."
		)
		else
			ShowDir rendDir
		
	on _dev pressed do
		ShowDir devDir
	
	on _psd pressed do
		ShowDir (devDir + @"etc\prjTemplate.psd")
	
	on _psd1 pressed do
		if ValidName() !=false then
		(
			prjLib() 
			if not ShowDir (prjDir + curPrj + @"\" + curPrj + ".psd") then
				messageBox "File not found."
		)
		else
			errorMsg "filename"
		
	on _nuke pressed do
		ShellLaunch nuke ("--nukex " + devdir + @"etc\NukeTemplate.nk")
	
	on _xml pressed do
	(
		local scriptFile = devDir + @"etc\prjDirTemplate.xml"
		edit scriptFile	
	)
		
	on _openPhotoshop pressed do
		ShowDir ps
	
	on _openNotepad pressed do
		ShowDir np
	
	on _openNuke pressed do
		ShellLaunch nuke "--nukex"
)
createdialog _commonTools width:300

)