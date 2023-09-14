macroScript VisibleByCategory
	category:"MyTools"
	toolTip:"Switches visibility of Cameras, Lights, Shapes and Helpers"
(
	state = true
	on execute do (
		hideByCategory.lights = state
		hideByCategory.cameras = state
		hideByCategory.helpers = state
		hideByCategory.shapes = state
		state = not state
	)	
)