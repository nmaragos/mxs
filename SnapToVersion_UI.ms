/*
	------------------------------------------
	Script	:	SnapShot to Version
	Date	:	July 2015
	------------------------------------------
	Notes	:	- check for currently open snapshot scene 
				- if current file is a main version file --> open respective snapshots folder
				- update version file
*/

------------------------------------------
--		Include Libraries / Files		--
------------------------------------------
--	prjLib()
--
------------------------------------------
(

fn UpdateVersionFile =
(
	if updateVer = querybox "Update scene version to current take ?\n\nWarning: Existing version will be overwritten!" title:"Update version" then 
	(	
		prjLib()
		new_mfn = substring maxfilename 1 (maxfilename.count - 9)
		savemaxfile (mfp + new_mfn)
	)
)

fn Snap2Ver = 
(
	case (filterstring maxfilename "_").count of
	(
		7:	(
				UpdateVersionFile()
			)
		6:	(
				prjLib()
				snapFileOpen = getOpenFileName filename:mfpsnap types:"SnapShot files(*.max)|*_t*.max" caption:"Load snapshot file"
				if snapFileOpen != undefined then
				(
					loadmaxfile snapFileOpen
					UpdateVersionFile()
				)
			)
		default: (
				snapFileOpen = getOpenFileName types:"SnapShot files(*.max)|*_t*.max" caption:"Load snapshot file"
				if snapFileOpen != undefined then
				(
					loadmaxfile snapFileOpen
					UpdateVersionFile()
				)
			)
	)
)


)