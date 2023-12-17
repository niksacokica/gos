gos:AddCommand({
	["cmd"] = "tasklist",
	["creator"] = "niksacokica",
	["description"] = "Displays all currently running apps.",
	["help"] = "TASKLIST [/FI filter]\n\nDescription:\n    This tool displays a list of currently running apps.\n\n" ..
		"Parameter List:\n   /FI    filter           Displays a set of apps whose name matches\n" ..
		"                           the name specified by the filter.",
	["function"] = function( args, window )
		if #args == 2 || ( #args > 1 and not ( string.upper( args[2] ) == "/FI" ) ) then
			return window:ExecuteCommand( "help tasklist" )
		end
		
		local ret = ""
		local srch = string.lower( table.concat( args, " ", 3 ) )
		for key, val in ipairs( gos.OpenApps ) do
			if #args == 1 || ( #args > 1 and string.lower( val[2] ) == srch ) then
				ret = ret .. val[2] .. " (id:" .. key .. ")\n"
			end
		end
			
		return ret
	end
})