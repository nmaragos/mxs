/*
	---------------------------------------------
	Script	:	Create SnapShot (Macro) v2.2
	Date	:	Dec 2017
	---------------------------------------------
	Notes	:	- save current take
				- create new take
				- leave version as is
				--- v2
					- create notes for each take
					- option to cancel save
				--- v2.1
					- create new take from a snapshot open file
*/

(
	
curTakeNum = (substring maxTake 2 3) as integer
upTake = curTakeNum + 1
newTake = "t" + formattedPrint upTake format:".3d"
	
rollout _newTake "Snapshot"
(
	label _ver "Version " across:4
	label _verNum ver
	label _take "Take " align:#right
	label _takeNum newTake
	label _notes "Notes:" align:#left
	edittext _takeNotes height:50 align:#center
	button _save "Save" across:2
	button _cancel "Cancel"
	
	on _cancel pressed do 
		DestroyDialog _newTake
	
	on _save pressed do 
	(
		if fnc.count == 7 then mfn = substring mfn 1 (mfn.count - 5) 	-- check whether we have a "take" file open and ammend filename...
		
		mfnSnap = mfn + "_" + newTake

		notesFileOut = mfpSnap + mfnSnap + ".txt"
		notesFile = createFile notesFileOut --mode:"wt"
		format _takeNotes.text to:notesFile
		format ("\n\n- Take created on " + localtime + "\n") to:notesFile
		format "---------------------------------------\n- Nikos - 2017\n\n" to:notesFile
		close notesFile
		if fnc.count == 7 then SaveFiles "snap2" else
			SaveFiles "snap"
		DestroyDialog _newTake
	)
)
CreateDialog _newTake
	

)