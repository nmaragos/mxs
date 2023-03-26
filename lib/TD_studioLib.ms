/*
	------------------------------------------
	Script	:	TD_StudioLib
	Date	:	July 2015 (rev. Mar 2019)
	------------------------------------------
	Notes	:	A set of commonly used 
	custom variables and functions that
	are directly related to a studio's
	pipeline conventions.
	Put in startup folder to automatically
	load with Max. (C:\Program Files\Autodesk\3ds Max 2016\stdplugs\stdscripts)
	
		Rev notes: 
			- Nov 2017:	- Added the GetDisCode function - reverse to GetDis
						- Optimised GetDis and GetDisCode functions
			- Mar 2019:	- V-Ray Next renderer
*/

-- define (network) drive(s)
global prjDrv = @"\\dlink\volume_1\"
global rendDrv = @"\\dlink\volume_1\"			
global pubCacheDrv = @"\\dlink\volume_1\"	
global localCacheDrv = @"F:\"
global devDrv = @"D:\"

-- define common paths
global homeDir = @"C:\Users\nmara\"
global prjDir = prjDrv + @"projects\3dsmax\"			-- projects directory
global rendDir = rendDrv + @"renders\"					-- renders directory
global cacheDir	= pubCacheDrv + @"caches\"				-- caches directory
global localCacheDir = localCacheDrv + @"caches\"		-- local caches directory
global libDir = devDrv + @"dev\mxs\lib\"				-- libraries directory
global devDir = devDrv + @"dev\mxs\"					-- development tools directory
global bbSnapDir = prjDrv + @"netrender\jobs\"			-- backburner submisions snapshots
global dbDir = @"E:\Dropbox\Client\"					-- dropbox client out dir
global odDir = @"D:\OneDrive\Δημόσιος\Client"
global assetLibDir = prjDrv + @"Library\FXAssetBrowser\"

-- external program locations
global ffmpeg = homeDir + @"ffmpeg\bin\ffmpeg.exe"
global rvio = @"C:\Program Files\ShotGrid\RV-2021.1.0\bin\rvio_hw.exe"
global rv = @"C:\Program Files\ShotGrid\RV-2021.1.0\bin\rv.exe"
global nuke = @"C:\Program Files\Nuke14.0v1\Nuke14.0.exe"
global rar = @"C:\Program Files\WinRAR\rar.exe"
global djv = homeDir + @"DJV-2.0.8-win64\bin\djv.exe"
global np = @"C:\Program Files\Notepad++\notepad++.exe"
global ps = @"C:\Program Files\Adobe\Adobe Photoshop 2021\photoshop.exe"

-- Deadline repository
global dlr = @"\\workstation3D\DeadlineRepository10\"

-- disciplines 
global disGrp = #("modelling", "look-dev", "lighting", "animation", "fx", "camera", "comp", "assets")		-- dir spec name
global disCode = #("mod", "ld", "lgt", "anim", "fx", "cam", "comp", "asset")								-- file spec name

-- renderers
renderVRay = V_Ray_6()

fn GetDis _disCode = disGrp[findItem disCode _disCode]

fn GetDisCode _dis = disCode[findItem disGrp _dis]

-- function to easily import lib file
fn prjLib =
(
	::filein (libDir + "prjLib.ms")
)

fn ValidName =
(
	case (filterstring maxfilename "_").count of
	(
		6 : "ValidVersion"
		7 : "ValidTake"
		default : false
	)
)
