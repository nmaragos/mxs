/*
	------------------------------------------
	Script	:	prjLib
	Date	:	July 2015 (Dec 2017 update**)
	------------------------------------------
	Notes	:	A set of commonly used
	custom variables and functions that
	directly relate to a scene and follow
	specific studio conventions.

	maxfile naming specifation : AA_001_001_fx_test_v001.max	(add '_t001' for snapshots)
	similar folder structure (although not defined here)

	** 	Sep 2017:	- updated SaveFiles function
		Dec 2017:	- opton to save cache files with takes (cdGen function)
					- updated the take variable to evaluate properly (introduce curTake & maxTake)
		Feb 2023:	- remove argument from DateTime function
*/

------------------------------------------
--		Include Libraries / Files		--
------------------------------------------
--
--
------------------------------------------

-- short for start/end animation frames in integer format
global fstart = animationrange.start as integer / ticksperframe
global fend = animationrange.end as integer / ticksperframe

-- update current date - time
DateTime()

-- omit the extension .max from filename
global mfn = substring maxfilename 1 (maxfilename.count - 4)

-- filename collector : array of the various chunks of file name divided by _
global fnc = filterstring mfn "_"

-- define the project name
tempPrj = substring maxfilepath (prjDir.count + 1) (maxfilepath.count - (prjDir.count +1))
prjFilter = filterstring tempPrj @"\"
global curPrj = prjFilter[1]

-- useful filename chunks
global prjCode = fnc[1]												-- project code 	eg. AA
global shotNum = fnc[2] + "_" + fnc[3]							-- shot number	eg. 001_001 (seq#_shot#)
global shotCode = prjCode + "_" + shotNum					-- shot code		eg. AA_001_001
global dis = fnc[4]														-- discipline		eg. fx
global elm = fnc[5]														-- element			eg. fireball
global ver = fnc[6]														-- version			eg. v001
if ValidName() == "ValidTake" then global curTake = fnc[7]

-- define current project dir
global prjPath = prjDir + curPrj + @"\"
global mfp = prjPath + @"shots\" + shotNum + @"\" + (GetDis dis) + @"\" + elm + @"\"

-- define publish dir
global mfpPub = prjPath + @"io\outgoing\" + shotNum + @"\" + (GetDis dis) + @"\" + elm + @"\"
global outDir = mfpPub + GetDate + @"\"

-- define snapshots dir
global mfpSnap = mfp + @"snapshots\"

-- find latest snapshot (take) for current file version
filesList = getfiles (mfpSnap + "*.max")

snapList = #()

for i in filesList do
(
	-- extract snapshot filename
	tmpFilename = substring i (mfpSnap.count +1) (i.count - mfpSnap.count)
	-- check file version
	if (filterstring tmpFilename "_")[6] == ver then
	(
		tmpFilename = (filterstring tmpFilename ".")[1]
		append snapList (filterstring tmpFilename "_")[7]
	)
)

if snapList.count != 0 then
	global maxTake = amax snapList
else
	global maxTake = "t000"

mfnSnap = mfn + "_" + maxTake

-- full output filenames
global fileOutPath = mfp + mfn
global fileOutPathSnap = mfpSnap + mfnSnap

-- render out parameters
global rendOutDir = rendDir + curPrj + @"\" + shotNum + @"\" + (GetDis dis) + @"\" + elm + @"\" + ver + @"\"
global ro = rendOutDir + mfn + "_.exr"

-- define global function names
-- global SaveFiles, SmartSave, UpdNotes, cdGen

fn SaveFiles _what =
(
	fileOutPath = mfp + mfn
	fileOutPathSnap = mfpSnap + mfnSnap
 	fileOutPathPub = outDir + mfn
	case _what of
	(
		"all" : (
					if ((savemaxfile fileOutPath) and (savemaxfile fileOutPathSnap useNewFile:false)) == true then
						messagebox (mfn + " succesfully saved in\n" + mfp + " \n\n" + mfnSnap + " succesfully saved in\n" + mfpSnap) title:"Save File" beep:false
				)
		"pub": (
					if ((savemaxfile fileOutPath) and (savemaxfile fileOutPathPub useNewFile:false)) == true then
						messagebox (mfn + " succesfully saved in\n" + mfp + " and in\n" + outDir) title:"Publish File" beep:false
				)
		"snap": (
					if (savemaxfile fileOutPathSnap useNewFile:false) == true then
						messagebox (mfnSnap + " succesfully saved in\n" + mfpSnap) title:"Snapshot" beep:false
				)
		"snap2": (
					if (savemaxfile fileOutPathSnap useNewFile:true) == true then
						messagebox (mfnSnap + " succesfully saved in\n" + mfpSnap) title:"Snapshot" beep:false
				)
	)
)

-- automatically create filenames for renderpasses and save
fn SmartSave _rPass =
(
	ssFile = shotCode + "_" + dis + "_" + elm + "-" + _rPass + "_" + ver
	ssRendDir = rendDir + curPrj + @"\" + shotNum + @"\" + (GetDis dis) + @"\" + elm + "-" + _rPass + @"\" + ver + @"\"
	ssRO = ssRendDir + ssFile + "_.exr"
	RRepath ssRendDir ssRO
	savemaxfile (mfp + ssFile)
)

-- add text to external txt file to create log
fn UpdNotes _pubFile =
(
	notesFileOut = outDir + mfn + " [pub].txt"
	notesFile = openFile notesFileOut mode:"at"
 	DateTime localtime
	format ("The " + _pubFile + " file was published on: " + timeString + "\n") to:notesFile
	close notesFile
)

-- cache directory generator
fn cdGen _cacheInput _path =		-- *** THE curTake VARIABLE NOT SURE IS WORKING !!! ***
(
	global cd = case _path of
	(
		"net": if ValidName() == "ValidVersion" then
					cacheDir + curPrj + @"\" + shotNum + @"\" + _cacheInput + @"\" + elm + @"\" + ver + @"\"
				else
					cacheDir + curPrj + @"\" + shotNum + @"\" + _cacheInput + @"\" + elm + @"\" + ver + @"\" + curTake + @"\"
		"local": if ValidName() == "ValidVersion" then
					localCacheDir + curPrj + @"\" + shotNum + @"\" + _cacheInput + @"\" + elm + @"\" + ver + @"\"
				else
					localCacheDir + curPrj + @"\" + shotNum + @"\" + _cacheInput + @"\" + elm + @"\" + ver + @"\" + curTake + @"\"
		"abc": if ValidName() == "ValidVersion" then
					localCacheDrv + @"projects\" + curPrj + @"\assets\" + dis + @"\abc\" + elm + @"\" + ver + @"\" + _cacheInput + @"\"
				else
					localCacheDrv + @"projects\" + curPrj + @"\assets\" + dis + @"\abc\" + elm + @"\" + ver + @"\" + curTake + @"\" + _cacheInput + @"\"
		default: if ValidName() == "ValidVersion" then
						_path + curPrj + @"\" + shotNum + @"\" + _cacheInput + @"\" + elm + @"\" + ver + @"\"
					else
						_path + curPrj + @"\" + shotNum + @"\" + _cacheInput + @"\" + elm + @"\" + ver + @"\" + curTake + @"\"
	)
)
