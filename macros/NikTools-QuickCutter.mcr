macroScript QuickCutter
category: "NikTools"
buttonText: "Quick Cutter"
(
	holdMaxFile()
	input = selection as Array
	cutter = copy input[1]
	deleteitem input 1
	cutter.name = "Cutter"
	ProCutter.CreateCutter #(cutter) 4 on on off on on
	ProCutter.AddStocks cutter input 4 1
	ProCutter.setPlanarEdgeRemoval cutter 2
	for cutter_obj in geometry where (findString cutter_obj.name "Cutter") != undefined do
	(
		CenterPivot cutter_obj
		cutter_obj.wirecolor = random black white
	)
	delete cutter
)