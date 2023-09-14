/*HeaderStart*******************************************************
:Created By:			Jan Janás
:Company:				INSOMNIA production s.r.o.
:Site:					http://JokerMartini.com
:Email:					jan.janas@insopro.cz
:Purpose:
	Allows the control of the camera rig setup.
	Gets a reference from the object as starting point. 

:History:
	V:0.00.01A 18/4/2023
		Getting started. 

:Todo:

:Bugs:

:Tests:
*******************************************************HeaderEnd*/

--Destroy the dialog if it is open. This is here for testing purposes. 
try(destroyDialog RndrSetupTool.instUI;RndrSetupTool.instUI=undefined)catch()

--Structure containing the tool
struct RndrSetupTool
(
	RndrSetupRoll=undefined,
	camHeight = $Controller_circle_center.position[3],
	camRadius = $Controller_circle_center.radius,
	camAngle = (custAttributes.get $Controller_circle_above 1)[1].value,
	detailRadius = $Controller_arc_detail.radius,
	detailHeight = $Controller_arc_detail.position[3],
	cams = #(),
	camIndex = 1,
	
	fn doSomething=
	(
		print "Do Something"
	),
	
	fn getCams =
	(
		select cameras
		deselect $*target
		RndrSetupTool.cams = $selection as array
		cam = getActiveCamera()
		if cam!=undefined do (
			for i in 1 to cams.count do (
				if cams[i] == cam do (
					RndrSetupTool.camIndex = i
				)
			)
		)
	),
	
	fn rotateBalls =
	(
		actionMan.executeAction 0 "40247"  -- Views: Select Viewport Node
		cam = $
		deselect
		balls = $refBalls_helper
		if balls.rotation.controller.getNode(1)!=undefined do (
			balls.rotation.controller.deleteTarget (1)
		)
		balls.rotation.controller.appendTarget cam 100
	),
	
	fn menu=
	(
		rcMenu myMenu
		(
			menuItem closeMnu "Close"
			menuItem testMnu "Test"
			
			on closeMnu picked do RndrSetupTool.run()
			on testMnu picked do RndrSetupTool.doSomething()
		)
	),
	
	fn ui=
	(
		rollout RndrSetupRoll "RndrSetupTool"
		(
			spinner camArrayAngle "CamAngle:" range:[20,40,camAngle] type:#integer toolTip:"Camera angle in degrees"
			on camArrayAngle changed camAngle do (
				(custAttributes.get $Controller_circle_above 1)[1].value = camAngle
				(custAttributes.get $Controller_circle_below 1)[1].value = -camAngle
			)
			spinner camArrayRadius "CamRadius:" range:[0,99999,camRadius] type:#float toolTip:"Camera array radius in centimeters"
			on camArrayRadius changed camRadius do (
				$Controller_circle_center.radius = camRadius
			)
			spinner camArrayHeight "CamHeight:" range:[0,99999,camHeight] type:#float toolTip:"Camera array height in centimeters"
			on camArrayHeight changed camHeight do (
				$Controller_circle_center.position = [0,0,camHeight]
			) 
			spinner camDetailRadius "DetailRadius:" range:[0,99999,detailRadius] type:#float toolTip:"Camera detail radius in centimeters"
			on camDetailRadius changed detailRadius do (
				$Controller_arc_detail.radius = detailRadius
			)
			spinner camDetailHeight "DetailHeight:" range:[0,99999,detailHeight] type:#float toolTip:"Camera detail height in centimeters"
			on camDetailHeight changed detailHeight do (
				$Controller_arc_detail.position = [0,0,detailHeight]
			) 
			button BtnGetRef "getRefObj" across:2 tooltip:"Get reference parameters from selected object" 
			edittext refName "" readOnly:true
			
			button BtnSetRef "setRefObj" across:3 align:#left enabled:false tooltip:"Set referenced parameters from selected object" 
			on BtnGetRef pressed do (
				refObj = pickObject()
				print (refObj.name+" selected as reference object")
				refName.text = refObj.name
				ctrlRef = $Controller_circle_ref
				ctrlRef[#transform][#position][#z_position].controller.setNode "object" refObj
				ctrlRef[#transform][#position][#z_position].controller.update()
				ctrlRef[#Object__Circle][#radius].controller.setNode "object" refObj
				ctrlRef[#Object__Circle][#radius].controller.update()
				BtnSetRef.enabled = true
			)
			on BtnSetRef pressed do (
				camArrayRadius.value = $Controller_circle_ref.radius
				$Controller_circle_center.radius = $Controller_circle_ref.radius
				camArrayHeight.value = $Controller_circle_ref.position[3]
				$Controller_circle_center.position = $Controller_circle_ref.position
			
			)
			button BtnPrev "<" offset: [25,0] tooltip:"Switch to previous camera" 
			button BtnNext ">" offset: [5,0]tooltip:"Switch to next camera" 
			on BtnPrev pressed do (
				RndrSetupTool.camIndex-=1
				if RndrSetupTool.camIndex < 1 do (
					RndrSetupTool.camIndex = RndrSetupTool.cams.count
				)
				prev = RndrSetupTool.cams[RndrSetupTool.camIndex]
				viewport.setCamera prev
				try (RndrSetupTool.rotateBalls())catch()
			)
			on BtnNext pressed do (
				RndrSetupTool.camIndex+=1
				if RndrSetupTool.camIndex > RndrSetupTool.cams.count do (
					RndrSetupTool.camIndex = 1
				)
				next = RndrSetupTool.cams[RndrSetupTool.camIndex]
				viewport.setCamera next
				try (RndrSetupTool.rotateBalls())catch()
			)
			
			
			on RndrSetupRoll close do 
			(
				RndrSetupTool.RndrSetupRoll=undefined
			)
		)
	),
	
	fn run=
	(
		if RndrSetupRoll==undefined then
		(
			ui()
			getCams()
			createDialog RndrSetupRoll --menu:(menu())
		)else
		(
			destroyDialog RndrSetupRoll
			RndrSetupRoll=undefined
		)
	),
	
	/*CommentStart*******************************************************
	This is here so that other tools can retreive the rollouts from this tool and display
		them in another UI
	*******************************************************CommentEnd*/
	fn getRollouts=(#(ui())),
		
	/*CommentStart*******************************************************
	MacroScript definition
		Will not work if you are encrypting your scripts
	*******************************************************CommentEnd*/
	
	macro=
	(
		macroScript RndrSetupToolMacro 
			category: "MyTools"
			buttonText: "RndrSetupTool"
		(
			on execute do 
			(
				if RndrSetupTool!=undefined do 
				(
					RndrSetupTool.run()
				)
			)
		)
	)
)
RndrSetupTool=RndrSetupTool()
RndrSetupTool.run() --Just here for testing. 

/* Print all subanims
(
	fn printAllSubanims pObj pDepth:0 = (
		for i in 1 to pObj.numSubs do (
			spaces =""
			for j in 1 to pDepth do spaces += "  "
				print (spaces + (getSubAnimName pObj i asString:False))
					printAllSubanims pObj[i] pDepth:(pDepth+1)
		)
	)
	if selection[1] != undefined then (
		printAllSubanims selection[1] pDepth:1
	)else(
		print "no objects selected!"
	)
)
*/