macroScript RndrSetupToolMacro
			category: "MyTools"
			buttonText: "RndrSetupTool"
		(
			on execute do 
			(
				if RndrSetupTool!=undefined then 
				(
					RndrSetupTool.run()
				)else (filein "MyTools-RndrSetupTool.ms")
			)
		)
