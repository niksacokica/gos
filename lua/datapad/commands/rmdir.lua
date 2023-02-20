datapad:AddCommand({
	["cmd"] = "rmdir",
	["creator"] = "niksacokica",
	["description"] = "Removes (deletes) a directory.",
	["help"] = "RMDIR [/S] path\n\n    /S      Removes all directories and files in the specified directory\n" ..
		"            in addition to the directory itself.  Used to remove a directory\n" ..
		"            tree.",
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
			
			local path = "datapad" .. "/" .. window:getTrueCurrentDir() .. "/" .. table.concat( args, " " )

			if not file.Exists( path, "DATA" ) then return "The system cannot find the directory specified.\n"
			elseif not file.IsDir( path, "DATA" ) then return "The directory name is invalid.\n"
			else
				local function delAll( path )
					local files, dirs = file.Find( path .. "/*", "DATA" )
					
					for k, v in ipairs( files ) do
						file.Delete( path .. "/" .. v )
					end
					
					for k, v in ipairs( dirs ) do
						delAll( path .. "/" .. v )
						file.Delete( path .. "/" .. v )
					end
				end
			
				if all then
					delAll( path )
				end
			
				file.Delete( path )
				if not all and file.Exists( path, "DATA" ) then return "The directory is not empty.\n" end
				
				window:appendText( "\n" )
			end
			
			if not file.Exists( "datapad/personal_files/appdata", "DATA" ) or not file.Exists( "datapad/personal_files/desktop", "DATA" ) or not file.Exists( "datapad/personal_files/documents", "DATA" ) then
				file.CreateDir( "datapad/personal_files/appdata" )
				file.CreateDir( "datapad/personal_files/desktop" )
				file.CreateDir( "datapad/personal_files/documents" )
			end
			
			return ""
		end
	
		return window:ExecuteCommand( "help rmdir" )
	end
})