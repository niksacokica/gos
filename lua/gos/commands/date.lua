gos:AddCommand({
	["cmd"] = "date",
	["creator"] = "niksacokica",
	["description"] = "Displays the date.",
	["help"] = "DATE",
	["function"] = function( args, window )
		return "The curret date is: " .. os.date( "%d.%m.%Y" ) .. "\n"
	end
})