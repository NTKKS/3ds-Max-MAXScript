macroScript FinalRndr
	category:"MyTools"
	toolTip:""
(
	arv = MAXToAOps.ArnoldRenderView()
	try (arv.Close())catch()
	denoiser = undefined
	try (arv.removeImager denoiser) catch()
	arv.setOption "Progressive Refinement" "0"
	renderers.current.progressive_render = false
	renderers.current.auto_build_tx = false
	renderers.current.use_existing_tx = true
	renderers.current.prepass_enabled = false
	renderers.current.render_device = 0
	--arv.Close()
)
