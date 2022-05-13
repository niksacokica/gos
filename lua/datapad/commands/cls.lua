datapad.addCommand({
	["cmd"] = "cls",
	["creator"] = "niksacokica",
	["description"] = "Clears the screen.",
	["help"] = "CLS",
	["function"] = function( args, window )
		window:SetText( "" )
		
		return ""
	end
})