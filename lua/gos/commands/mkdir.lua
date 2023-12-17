gos:AddCommand({
	["cmd"] = "mkdir",
	["creator"] = "niksacokica",
	["description"] = "Creates a directory.",
	["help"] = "MKDIR path\n\nMKDIR creates any intermediate directories in the path, if needed.",
	["function"] = function( args, window )
		if #args > 1 then
			table.remove( args, 1 )

			file.CreateDir( "gos" .. "/" .. window:getTrueCurrentDir() .. "/" .. table.concat( args, " " ) )
			window:appendText( "\n" )
			
			return ""
		end
	
		return window:ExecuteCommand( "help mkdir" )
	end
})