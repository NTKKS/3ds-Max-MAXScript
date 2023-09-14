macroScript NTKKS_tools
category:"DragAndDrop"
category: "MyTools"  
buttonText: "NTKKS tools"

------------------------------------------------------------------------------------------------------------------------------
-- NTKKS tools v1.1 - 13/09/2022
-- Dev by Jan Jan�s 
-- updates: min-Z pivot for each object
-- TODO: pivot center per object
------------------------------------------------------------------------------------------------------------------------------

(
	try (closeRolloutFloater ntkksTools) catch () --closes rolloutFloater if it is opened

	--default floater setup
	top = 2010		--horizontal rolloutFloater position
	left = 485		--vertical rolloutFloater position

	rollout toolsRollout "NTKKS tools"
	(
		button pivotBtn "pivot" across:2
		on pivotBtn pressed do
		(
			rollout pivotRollout "Pivot actions"
			(
				button minzBtn "pivot min-Z"
				on minzBtn pressed do
				(	if $ == selection then
					(
					for i = 1 to $.count do $[i].pivot = [$[i].center.x,$[i].center.y,$[i].min.z]
					)
					if $ == undefined then ()
					if $ != selection and $ != undefined then
					(
					$.pivot = [$.center.x,$.center.y,$.min.z]	
				)
				DestroyDialog pivotRollout
				)
				
				button centerBtn "pivot center"
		
				on centerBtn pressed do
				(
					$.pivot = [$.center.x,$.center.y,$.center.z]
					DestroyDialog pivotRollout
				)
				
				button Btn07 "pivot [0,0,0]"
				
				on Btn07 pressed do
				(
					$.pivot = [0,0,0]
					DestroyDialog pivotRollout
				)
				
			)
			createDialog pivotRollout
		)
			
		button Btn02 "zero pos"
		
		on Btn02 pressed do
		(
			$.position = [0,0,0]
		)
		
		button Btn03 "basic color"
		
		on Btn03 pressed do
		(
			$.wirecolor = color 0 0 0
			$.material = meditMaterials[1]
		)
		
		button Btn04 "lock $ " across:2
		
		on Btn04 pressed do
		(
			setTransformLockFlags selection #all
		)
		
		button Btn05 "unlock $ "
		
		on Btn05 pressed do
		(
			setTransformLockFlags selection #none
		)
		
		button Btn09 "RenderableSwitch" tooltip:"switches Renderable and displayAsBox"
		
		on Btn09 pressed do
		(
			if $ == selection then (
				for i = 1 to $.count do
				(
					if $[i].renderable == true then (
						$[i].renderable = false
						$[i].boxMode = true
					) else (
						$[i].renderable = true
						$[i].boxMode = false
					)	
				)
			)
			if $ == undefined then ()
			if $ != selection and $ != undefined then
			(
				if $.renderable == true then (
					$.renderable = false
					$.boxMode = true
				) else (
					$.renderable = true
					$.boxMode = false
				)	
			)
			
		)
		
		button Btn08 "CollapseDedStruct"
		
		on Btn08 pressed do
		(
			polyop.collapseDeadStructs $
		)
		
	)

	ntkksTools = newRolloutFloater "" 150 130 top left
	addrollout toolsRollout ntkksTools
)
