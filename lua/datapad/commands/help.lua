datapad:AddCommand({
	["cmd"] = "help",
	["creator"] = "niksacokica",
	["description"] = "Provides help information for commands.",
	["help"] = "HELP [command]\n\n    command - displays help information on that command.",
	["function"] = function( args, window )
		local ret = ""
		
		if #args == 1 then
			ret = "For more information on a specific command, type HELP command-name\n"
			
			for k, v in SortedPairs( datapad.cmds ) do
				if #v["description"] > 0 then
					ret = ret .. k .. string.rep( " ", 15 - #k ) .. v["description"] .. "\n"
				end
			end
		else
			local hlp = string.lower( args[2] )
			if istable( datapad.cmds[hlp] ) and #datapad.cmds[hlp]["help"] > 0 then
				ret = datapad.cmds[hlp]["description"] .. "\n\n" ..
					datapad.cmds[hlp]["help"] .. "\n"
			else
				ret = "This command is not supported by the help utility. Try \"" .. hlp .. " /?\".\n"
			end
		end
		
		return ret
	end
})