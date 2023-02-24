datapad:AddSetting({
	["setting"] = "mm_rot_sens",
	["creator"] = "niksacokica",
	["title"] = "Minimap Rotation Sensitivity",
	["description"] = "Adjust the rotation sensitivity.",
	["category"] = "minimap",
	["subCategory"] = "sensitivity",
	["function"] = function( args, window )
		return 0.03, 0.06
	end
})