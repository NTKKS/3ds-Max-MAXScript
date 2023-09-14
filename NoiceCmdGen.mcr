------------------------------------------------------------------------------------------------------------------------------
-- Name v0.01 - DD/MM/YYY - DD/MM/YYY
-- Created by Jan Janás
--
--	Description:
--		Lorem ipsum dolor sit amet
--		Lorem ipsum dolor sit amet
--
-- Known limitations:
-- * 
--
-- New in v0.01:
-- * Lorem ipsum dolor sit amet
--
-- To Do:
-- * Lorem ipsum dolor sit amet
--
-- Usefull commands for developement:
--	getPropNames
--	classOf, superClassOf..
--	showClass
--	showProperties 
--	showInterfaces
--	max ?
--	sysInfo
--	sysInfo.DesktopSize == [3840,1080]
--	sysInfo.userName == "Insomnia_3D_03"
--	HSV to Float = H/3,6; S/100; V/100
------------------------------------------------------------------------------------------------------------------------------
try(closeRolloutFloater NoiceCMDGen.mainRoll)catch()

struct NoiceCMDGen (
	
	-- Variables

	uiInst = undefined,
	mainRoll = undefined,
	verStr = "0.01",
	startframe = animationRange.start.frame as Integer,
	endframe = animationRange.end.frame as Integer,
	arnold_bin_path = "/Applications/Autodesk/Arnold/mtoa/2022/bin",
	variance = "0.5",
	pixel_search_radius = "9",
	pixel_neighborhood_patch_radius = "3",
	temporal_range = "2",
	light_aov_names = #(), -- if no light aov denoising needed, just leave list empty: ()
	aovs = #("diffuse","specular","transmission","volume"),
	code = "",
	
	--	Functions
	fn setup _init = (
		try(
			if _init=="init" do (
				startframe = animationRange.start.frame as Integer
				endframe = animationRange.end.frame as Integer
			)
			case of (
				(startFrame<10):	prefix = "000"
				(startFrame<100):	prefix = "00"
				(startFrame<1000):	prefix = "0"
				(startFrame>=1000):	prefix = ""
			)
		
			numbering = prefix + startFrame as String
			filename_input = renderers.current.AOV_Manager.Drivers[1].filenameSuffix+numbering+".exr"
			filename_noice = renderers.current.AOV_Manager.Drivers[3].filenameSuffix+"_"+numbering+".exr"
			basePath = renderers.current.AOV_Manager.Drivers[1].filenameSuffix
			filename_output = (substring (basePath) 1 (basePath.count-5)) +"denoised_AOVS_"+ numbering+".exr"
		
			aovsList = ""
			for aov in aovs do (
				aovsList += ("-l "+aov+"\n")
			)
			
			frames = (NoiceCMDGen.endframe-NoiceCMDGen.startframe+1) as String
			
			code = 
"set IMAGES=\""+renderers.current.AOV_Manager.outputPath+"\"
set ARNOLD_BIN=C:\ProgramData\Autodesk\ApplicationPlugins\MAXtoA_2023\n\n
%ARNOLD_BIN%\\noice ^ 
-ef "+temporal_range+" -sr "+pixel_search_radius+" -pr "+pixel_neighborhood_patch_radius+" -v "+variance+" -f "+frames+" ^
-i %IMAGES%\\"+filename_input+" ^
-i %IMAGES%\\"+filename_noice+" ^
"+aovsList+"
-o %IMAGES%\\"+filename_output+" ^"
			
			) catch (
				messageBox"AOVs are not setup correctly"
				NoiceCMDGen.code = "AOVs are not setup correctly!!!\nUse the AOVWizzard tool to set the Noice AOVs"
			)
	),

	--	UI
	fn ui = (
		
			-- Graphics setup rollout 
			rollout NoiceCMDGenRoll "NoiceCMDGen"
			(
				spinner startField "start frame:" fieldWidth:100 align:#left across:2 range: [0,9999,startframe]  type: #integer tooltip:"Frame to start denoising from." 
				spinner varianceField "variance:" fieldWidth:100 align:#left range: [0,1,variance as Float] type: #float tooltip:"Frame to start denoising from." 
				spinner endField "  end frame:" fieldWidth:100 align:#left across:2 range: [0,9999,endframe] type:#integer scale: 0.01 tooltip:"Last frame to denoise."
				editText aovsField "    AOVs:" fieldWidth:100 align:#left text:""  tooltip:"Last frame to denoise."
				
				-- code field
				edittext codeField fieldWidth:765 height:225 text:code
			
				on startField changed val do (
					NoiceCMDGen.startFrame = startField.value
					if startField.value > endField.value do (
						NoiceCMDGen.endFrame = startField.value
						endField.value = startField.value
					)
					NoiceCMDGen.setup("")
					codeField.text = NoiceCMDGen.code
				)
				
				on endField changed val do (
					NoiceCMDGen.endFrame = endField.value
					if endField.value < startField.value do (
						NoiceCMDGen.startFrame = endField.value
						startField.value = endField.value
					)
					NoiceCMDGen.setup("")
					codeField.text = NoiceCMDGen.code
				)
				
				on varianceField changed val do (
					NoiceCMDGen.variance = varianceField.value as String
					NoiceCMDGen.setup("")
					codeField.text = NoiceCMDGen.code
				)
				
			on NoiceCMDGenRoll close do (NoiceCMDGen.uiInst=undefined)
			)
			
			NoiceCMDGen.MainRoll = newRolloutFloater ("NoiceCMDGen "+verStr) 800 300
			addrollout NoiceCMDGenRoll NoiceCMDGen.MainRoll

	),
	
	--returns array of rollouts
	fn getRollouts=(
		mainRoll.rollouts
	),
	
	fn run = (
		if uiInst == undefined then (
			NoiceCMDGen.setup("init")
			uiInst = NoiceCMDGen.ui()
			print "NoiceCMDGen launched"
		)else (
			closeRolloutFloater NoiceCMDGen.mainRoll
			uiInst=undefined
			print "NoiceCMDGen closed"
		)
	),
	
	macro = (
		macroScript NoiceCMDGen
			category: "MyTools"  
			buttonText: "NoiceCMDGen"
		(
			on execute do (
				if NoiceCMDGen != undefined then NoiceCMDGen.run()
				else (
					print "NoiceCMDGen undefined"
					filein "NoiceCMDGen.mcr"
				)
			)
		)	
	)
)
--make structure instance
NoiceCMDGen = NoiceCMDGen()
NoiceCMDGen.run()






