datapad:AddSetting({
	["setting"] = "mm_draw_ply",
	["creator"] = "niksacokica",
	["title"] = "Minimap Draw Other Player",
	["description"] = "Enable/disable the drawing of other player.",
	["category"] = "minimap",
	["subCategory"] = "drawing",
	["function"] = function( args, window )
		return 0.03, 0.09
	end
})