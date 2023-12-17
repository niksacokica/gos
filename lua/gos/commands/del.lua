gos:AddCommand({
	["cmd"] = "del",
	["creator"] = "niksacokica",
	["description"] = "Deletes one or more files.",
	["help"] = "DEL [/S] names\n\n" ..
		"  names         Specifies a list of one or more files or directories.\n" ..
		"                Wildcards may be used to delete multiple files. If a\n" ..
		"                directory is specified, all files within the directory\n" ..
		"                will be deleted.\n" ..
		"  /S            Delete specified files from all subdirectories.",
	["function"] = function( args, window )
		if #args > 1 then
			table.remove( args, 1 )
			
			local all = false
			if string.upper( args[1] ) == "/S" then
				all = true
				table.remove( args, 1 )
			elseif string.upper( args[#args] ) == "/S" then
				all = true
				table.remove( args )
			end
			
			local path = table.concat( args, " " )
			local fullPath = "gos" .. "/" .. window:getTrueCurrentDir() .. "/" .. path
			if file.IsDir( fullPath, "DATA" ) then return window:ExecuteCommand( "rmdir" .. ( all and " /S " or " " ) .. path )
			else
				local function delAll( path, fileName )
					local _, dirs = file.Find( path .. "*", "DATA" )
					local files, _ = file.Find( path .. fileName, "DATA" )
					
					for k, v in ipairs( files ) do
						file.Delete( path .. v )
					end
					
					for k, v in ipairs( dirs ) do
						delAll( path .. v .. "/", fileName )
						file.Delete( path .. v )
					end
				end
				
				local pathNoFile = string.GetPathFromFilename( fullPath )
				local files, dirs = file.Find( fullPath, "DATA" )
				for k, v in ipairs( files ) do
					file.Delete( pathNoFile .. "/" .. v )
				end
			
				if all then
					delAll( pathNoFile, string.GetFileFromFilename( fullPath ) )
				end
			end
			
			window:appendText( "\n" )
			return ""
		end
	
		return window:ExecuteCommand( "help del" )
	end
})