/*
	----------------------------------------
	Script	:	Version Up v2.01 (Macro)
	Date	:	July 2015
	----------------------------------------
	Notes	:	Increase current scene
	version by one. If a previous scene
	is opened check for latest version.
	
	2.01 -- moved prjLib() to NikTools.mcr
*/

(
	
-- Include Libraries / Files --
-- prjLib()
----------------------------------

curVer = (substring ver 2 3) as integer
upVer = curVer + 1
newVer = "v" + formattedPrint upVer format:".3d"

mfnUp = shotCode + "_" + dis + "_" + elm + "_" + newVer
fileUpOut = mfp + mfnUp
	
fn LatestVersion &newerVer =
(
	filesList = getfiles (mfp + "*.max")
	verList = #()
	for i in filesList do
	(
		verFilename = substring i (mfp.count + 1) (i.count - mfp.count)
		tmpVer = (filterstring verFilename ".")[1]
		append verList (filterstring tmpVer "_")[6]
	)
	latestVer = amax verList
	latestVerNum = (substring latestVer 2 3) as integer
	upVer = latestVerNum + 1
	newerVer = "v" + fp upVer 3
)

fn SetRenderOut _ver &rendOutDir &ro =
(
	rendOutDir = rendDir + curPrj + @"\" + shotNum + @"\" + (GetDis dis) + @"\" + elm + @"\" + _ver + @"\"
	ro = rendOutDir + mfn + "_.exr"
)

fn version =
(
	if (doesFileExist (fileUpOut + ".max")) then 
	(
		verQuery = yesNoCancelBox ("File version " + (formattedPrint upVer format:".3d") + 
			" already exists... Ovewrite?\n\n<Yes> to overwrite with current file\n<No> to create newer version\n<Cancel> to cancel") \
			title:"File version conflict"
			
		if verQuery == #yes then 
		(
			mfn = mfnUp
			mfnSnap = mfn + "_t001"
			SetRenderOut newVer &rendOutDir &ro
			RRepath rendOutDir ro
			SaveFiles "all"
		)
		else if verQuery == #no do
		(
			LatestVersion &newerVer
			mfn = shotCode + "_" + dis + "_" + elm + "_" + newerVer
			mfnSnap = mfn + "_t001"
			SetRenderOut newerVer &rendOutDir &ro
			RRepath rendOutDir ro
			SaveFiles "all"
		)
	)
	else
	(
		mfn = mfnUp
		mfnSnap = mfn + "_t001"
		SetRenderOut newVer &rendOutDir &ro
		RRepath rendOutDir ro
		SaveFiles "all"
	)
)


)