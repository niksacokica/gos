datapad:AddCommand({
	["cmd"] = "del",
	["creator"] = "niksacokica",
	["description"] = "Deletes one or more files.",
	["help"] = "DEL [/S] names\n\n" ..
		"  names         Specifies a list of one or more files or directories.\n" ..
		"                Wildcards may be used to delete multiple files. If a\n" ..
		"                directory is specified, all files within the directory" ..
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
			
			local path = "datapad" .. "/" .. window:getTrueCurrentDir() .. "/" .. table.concat( args, " " )
			if not file.Exists( path, "DATA" ) then return "The system cannot find the path specified.\n"
			elseif file.IsDir( path, "DATA" ) then
				local tab1, tab2 = file.Find( name, "DATA" )
				PrintTable(tab1)
				PrintTable(tab2)
			end
			
			return ""
		end
	
		return window:ExecuteCommand( "help del" )
	end
})