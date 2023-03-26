/*
	------------------------------------------
	Script	:	TD_StartUpLib v3.4
	Date	:	Nov. 2018
	------------------------------------------
	Notes	:	A set of commonly used 
	custom variables and functions that
	do not directly relate to a scene.
	Put in startup folder to automatically
	load with Max. (C:\Program Files\Autodesk\3ds Max 2xxx\stdplugs\stdscripts)
	
	Version Update : 2.1 - Changed the RRepath function to update render setup dialog even if open 
						3.0 - Added GetProjects and GetSubDirs functions
						3.1 - Added the existFile function
						3.2 - Added CopyTextToClipboard and SetPermissions functions
						3.3 - Changed the format of timeString global (DateTime function)
							- Ommit the parameter for DateTime function. Always use "localtime"
						3.4 - Added recurseFolders function
							- Added makeDirFromXML function
*/

fn existFile fname = (getfiles fname).count != 0

fn ShowDir _dir = 		-- TO BE RENAMED TO "Launch"
(
	shelllaunch _dir ""
)
timestamp
-- format a given number (_num) with padding (_pad)
fn fp _num _pad =
(
	formattedPrint (_num as integer) format:("." + (_pad as string) + "d")
)

-- format a specified system date/time input to format : YYYY-MM-DD and H-M-am/pm
fn DateTime  =
(
	parse_time = filterstring localtime " "

	parseDate = filterstring parse_time[1] "/"
	day = fp parseDate[1] 2
	month = fp parseDate[2] 2
	year = substring parseDate[3] 3 2
	global getDate = day + "-" + month + "-" + year

	parseTime = filterstring parse_time[2] ":"
	if parse_time[3] == "µµ" or parse_time[3] == "pm" then
	(
		parseTime[1] = ((parseTime[1] as integer) + 12) as string
		print parseTime[1]
	)
	else
		parseTime[1] = append "0" parseTime[1]
-- 	getTime = parseTime[1] + "-" + parseTime[2]
	getTime = parseTime[1] + parseTime[2]

	global timeString = getDate + "-" + getTime
)

-- NOT WORKING PROPERLY BECAUSE IT IS NOT DYNAMICALLY UPDATED FOR EACH SCENE
-- fn AnimRange =
-- (
-- 	fend - fstart
-- )

-- similar to AnimRane but gets start/end frames from render settings
fn RenderRange = 
(
	renderStart = rendstart as integer / ticksperframe
	renderEnd = rendend as integer / ticksperframe
	renderEnd - renderStart
)

-- render repath function
fn RRepath _dir _file =
(
	rc = renderers.current
-- 	renderSceneDialog.close()
	makedir _dir
	rendoutputfilename = _file
	try 
	(
		rc.output_rawFileName = _file
	) catch()
	renderSceneDialog.update()
)

-- check if given input is number (integer) 
fn isNumeric _str =
(
    try
    (
        (_str as integer) != undefined
    )
    catch(false)
)

fn errorMsg _type =
(
	titleLbl = "Error..."
	case _type of
	(
		"filename": messageBox "Not valid scene name." title:titleLbl
		"duplicate": messageBox "File already exists." title:titleLbl
		"general": messageBox "Generic error." title:titleLbl
	)

)

fn existFile fname = (getfiles fname).count != 0

-- move cache data
fn cacheMove _cIn _cOut =
(
	HiddenDOSCommand ("robocopy " + _cIn + " " + _cOut + " /IS /IT") prompt:"Copying cache files..." donotwait:true
	
-- 	if exitCode == 0 then messageBox "Cache files succesfully copied to network location." beep:false title:"cacheMove"
-- 	else messageBox "Cache files copying unsuccesful." title:"cacheMove"
)

fn GetProjects _dir =
(
	global projects = #()
	
	for i in _dir do
	(
		local listItem = filterstring i @"\"
		append projects listItem[listItem.count]
	)
)

fn GetSubDirs _root = 
(
	global subList = #()
	local subDir = getDirectories (_root + @"\*")
	
	for i in subDir do
	(
		local listItem = filterstring i @"\"
		append subList listItem[listItem.count]
	)
)

fn recurseFolders fPath =
(
	if doesFileExist fPath do
	(
		dirs = getDirectories(fPath + "*")
		for d in dirs do
		(
			print d
			recurseFolders d
		)
	)
)

fn CopyTextToClipboard _text =
(
	clipboardClass = dotNetClass "System.Windows.Forms.Clipboard"
	clipboardClass.setText _text
	clipboardClass.ContainsText()
)

fn SetPermissions _dir =
(
	setPermCmd = "icacls " + _dir + " /grant:r Everyone:(OI)(CI)F /T"
	HiddenDOSCommand setPermCmd prompt:"Setting folder permissions..." donotwait:true
)

fn makeDirFromXML root location:"" =
(
	childNodes = root.childNodes
	for i = 0 to (childNodes.count - 1) do
	(
		entry = childNodes.ItemOf[i]
		folderName = entry.getAttribute "name"
		makeDir (location + @"\" + folderName)
		makeDirFromXML entry location:(location + @"\" + folderName)
	)
		
)
