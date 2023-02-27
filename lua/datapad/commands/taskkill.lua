datapad:AddCommand({
	["cmd"] = "taskkill",
	["creator"] = "niksacokica",
	["description"] = "Stop a running app.",
	["help"] = "TASKKILL [/FI filter | /ID appid]\n\nDescription:\n    This tool is used to terminate apps by app id.\n\n" ..
		"Parameter List:\n    /FI   filter           Terminates all apps with the name specified.\n\n" ..
		"    /ID   appid            Specifies the ID of the app to be terminated.\n" ..
		"                           Use TaskList to get the ID.\n" ..
		"                           NOTE: After each taskkill, IDs of apps change.",
	["function"] = function( args, window )
		local num = tonumber( args[3] )
		
		if not ( ( #args == 3 and string.upper( args[2] ) == "/ID" and num ) ||
			( #args > 2 and string.upper( args[2] ) == "/FI" ) ) then
			return window:ExecuteCommand( "help taskkill" )
		end
		
		local ret = ""
		local srch = string.lower( table.concat( args, " ", 3 ) )
		if string.upper( args[2] ) == "/FI" then
			ret = "Successfully terminated the following apps:\n"
			for key, val in ipairs( datapad.OpenApps ) do
				if string.lower( val[2] ) == srch then
					ret = ret .. val[2] .. " (id:" .. key .. ")\n"
					val[1]:Remove()
				end
			end
			
			ret = ( ret == "Successfully terminated the following apps:\n" and "ERROR: No apps with name \"" .. srch .. "\" found.\n"  or ret )
		else
			local exists = ( num <= #datapad.OpenApps and num > 0 )
			
			ret = ( exists and "Successfully terminated the app with the id " .. num .. ".\n" or
				"ERROR: The app with the id of " .. num .. " not found.\n" )
			datapad.OpenApps[num][1]:Remove()
		end
		
		return ret
	end
})