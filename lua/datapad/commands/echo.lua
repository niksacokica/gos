datapad.addCommand({
	["cmd"] = "echo",
	["creator"] = "niksacokica",
	["description"] = "Displays messages, or turns command echoing on or off.",
	["help"] = "  ECHO [ON | OFF]\n\n  ECHO [message]\n\n Type ECHO without parameters to display the current echo setting.",
	["function"] = function( args, window )
		if #args == 1 then
			return "ECHO is " .. ( window.echo and "on" or "off" ) .. ".\n"
		elseif #args == 2 and ( string.upper( args[2] ) == "ON" || string.upper( args[2] ) == "OFF" ) then
			window:SetEcho( string.upper( args[2] ) == "ON" and true or false )
			return ""
		end
		
		return table.concat( args, " ", 2 ) .. "\n"
	end
})