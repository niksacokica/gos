datapad:AddCommand({
	["cmd"] = "rename",
	["creator"] = "niksacokica",
	["description"] = "Renames a file or directory.",
	["help"] = "RENAME [path]filename1 filename2.\n\n Note that you cannot specify a new path for your destination file.\n\n" ..
		" The filename must end with one of the following:\n" ..
		"          .txt, .dat, .json, .xml, .csv, .jpg,\n" ..
		"          .jpeg, .png, .vtf, .vmt, .mp3, .wav,\n" ..
		"          .ogg!\n\n" ..
		" Restricted symbols are: \" :",
	["function"] = function( args, window )
		if #args > 2 then
			local path = "datapad" .. "/" .. window:getTrueCurrentDir()
		
			table.remove( args, 1 )
			local newName = args[#args]
			table.remove( args )
			
			local oldName = table.concat( args, " " )
			local first = true
			local ind = 0
			for i = #oldName, 1, -1 do
				if oldName[i] == "/" or oldName[i] == "\\" then
					if first then
						oldName = string.Left( oldName, #oldName - 1 )
						first = false
					else
						ind = i
						break
					end
				else
					first = false
				end
			end
			
			if file.Rename( path .. "/" .. oldName, path .. "/" .. string.Left( oldName, ind ) .. newName ) then			
				window:appendText( "\n" )
				return ""
			end
		end
	
		return window:ExecuteCommand( "help rename" )
	end
})