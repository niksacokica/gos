datapad.addCommand({
	["cmd"] = "time",
	["creator"] = "niksacokica",
	["description"] = "Displays the time.",
	["help"] = "TIME",
	["function"] = function( args, window )
		return "The curret time is: " .. os.date( "%H:%M" ) .. "\n"
	end
})