gos:AddCommand({
	["cmd"] = "type",
	["creator"] = "niksacokica",
	["description"] = "Displays the contents of a text file or files.",
	["help"] = "TYPE [path]filename",
	["function"] = function( args, window )
		if #args > 1 then
			table.remove( args, 1 )
			local path = "gos" .. "/" .. window:getTrueCurrentDir() .. "/" .. table.concat( args, " " )
			
			if not file.Exists( path, "DATA" ) then return "The system cannot find the file specified.\n"
			elseif file.IsDir( path, "DATA" ) then return "Access is denied.\n"
			else return file.Read( path, "DATA" ) end
		end
	
		return window:ExecuteCommand( "help type" )
	end
})