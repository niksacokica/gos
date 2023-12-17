gos:AddCommand({
	["cmd"] = "start",
	["creator"] = "niksacokica",
	["description"] = "Starts the specified app.",
	["help"] = "START app_name",
	["function"] = function( args, window )
		if #args > 1 then
			table.remove( args, 1 )
			
			local app_name = table.concat( args, " " )
			if not gos.apps[string.lower( app_name )] then return "The system cannot find the app specified.\n" end
			
			gos:StartApp( gos.apps[app_name] )
			return ""
		end
	
		return window:ExecuteCommand( "help start" )
	end
})