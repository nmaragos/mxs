/*
	-------------------------------------
	Script	:	Publish Scene (Macro)
	Date	:	July 2015
	-------------------------------------
	Notes	:	- publish scence
				- create/update .txt file with publish info
				- version up
*/
(
	
fn GoPublish =
(
	makedir outDir
	SaveFiles "pub"
	updNotes maxfilename
	::filein (devDir + "VersionUp.ms")	
)

pubFile = outDir + maxfilename

if doesFileExist pubFile then
(
	if queryBox ("This version has already been published on " + getFileModDate pubFile + \
		" !\n Do you want to ovewrite it ?") title:"File version conflict" then GoPublish()
)	
else
(
	if queryBox ("Scene " + mfn + "\n" + "Publishing on " + localTime) title:"Publish scene" then GoPublish()
)

 
)