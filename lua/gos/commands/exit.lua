gos:AddCommand({
	["cmd"] = "exit",
	["creator"] = "niksacokica",
	["description"] = "Exits the command prompt.",
	["help"] = "EXIT",
	["function"] = function( args, window )
		window:Close()
		
		return ""
	end
})