datapad:AddSetting({
	["setting"] = "mm_pan_sens",
	["creator"] = "niksacokica",
	["title"] = "Minimap Panning Sensitivity",
	["description"] = "Adjust the pan sensitivity.",
	["category"] = "minimap",
	["subCategory"] = "sensitivity",
	["function"] = function( args, window )
		return 0.03, 0.06
	end
})