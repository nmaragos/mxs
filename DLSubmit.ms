(
prjLib()

global SMTDSettings
global SMTDFunctions

local smtd_funcList = dlr + @"submission\3dsmax\Main\SubmitMaxToDeadline_Functions.ms"
filein smtd_funcList


-- Define job properties
SMTDFunctions.loadSettings()
SMTDSettings.JobName = mfn

SMTDSettings.Priority = 75
SMTDSettings.Comment = "Insert comment here..."

-- Make copy of scene file
local maxFileToSubmit = SMTDPaths.tempdir + mfn + ".max"
SMTDFunctions.SaveMaxFileCopy maxFileToSubmit

-- Create render job files
local submitInfoFile = SMTDPaths.tempDir + "\\max_submit_info.job"
local jobInfoFile = SMTDPaths.tempDir + "\\max_job_info.job"

SMTDFunctions.CreateSubmitInfoFile submitInfoFile
SMTDFunctions.CreateJobInfoFile jobInfoFile

-- Submit job
local submitString = "\"" + submitInfoFile + "\" \"" + jobInfoFile + "\" \"" + maxFileToSubmit + "\""
SMTDFunctions.WaitForCommandToComplete submitString SMTDSettings.TimeoutSubmission

SMTDFunctions.GetJobIDFromMessage (SMTDFunctions.GetRenderMessage())
jobId = SMTDSettings.DeadlineSubmissionLastJobID

messagebox ( SMTDFunctions.GetRenderMessage() )
)
