macroScript IPR
	category:"MyTools"
	toolTip:"IPR"
(
	arv = MAXToAOps.ArnoldRenderView()
	try (arv.Close())catch()
	arv.setOption "Progressive Refinement" "1"
	renderers.current.progressive_render = true
	renderers.current.auto_build_tx = true	
	renderers.current.use_existing_tx = true
	try (arv.removeimager denoiser) catch()
	denoiser = arv.AddImager #DenoiserOidn
	--arv.AddImager #DenoiserOptix
	--renderers.current.render_device = 1
	renderers.current.render_device = 0
	--arv.Close()
)
