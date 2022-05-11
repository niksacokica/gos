datapad.addCommand({
	["cmd"] = "help",
	["creator"] = "niksacokica",
	["description"] = "Provides help information for commands.",
	["help"] = "HELP [command]\n\n    command - displays help information on that command.",
	["function"] = function( args )
		local ret = ""
		
		if #args == 1 then
			ret = "For more information on a specific command, type HELP command-name\n"
			
			for k, v in pairs( datapad.cmds ) do
				ret = ret .. k .. string.rep( " ", 15 - #k ) .. v["description"] .. "\n"
			end
		else
			local hlp = string.lower( args[2] )
			if istable( datapad.cmds[hlp] ) then
				ret = datapad.cmds[hlp]["description"] .. "\n\n" ..
					datapad.cmds[hlp]["help"] .. "\n"
			else
				ret = "This command is not supported by the help utility." .. "\n"
			end
		end
		
		return ret
	end
})