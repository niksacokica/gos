datapad:AddCommand({
	["cmd"] = "cd",
	["creator"] = "niksacokica",
	["description"] = "Displays the name of or changes the current directory.",
	["help"] = "CD [path]\n\n  ..   Specifies that you want to change to the parent directory.\n" ..
		"Type CD without parameters to display the current drive and directory.\n\n",
	["function"] = function( args, window )
		if #args == 1 then
			return window:getCurrentDir() .. "\n"
		end
		
		local curPath = window:getTrueCurrentDir()
		local paths = string.Explode( "[/\\]+", table.concat( args, " ", 2 ), true )
		for k, v in ipairs( paths ) do
			if v == ".." then
				local parents = string.Explode( "/", curPath )
				curPath = table.concat( parents, "/", 1, math.max( #parents - 1, 1 ) )
				continue
			elseif file.Exists( "datapad/" .. curPath .. "/" .. v, "DATA" ) then
				curPath = curPath .. "/" .. v
				continue
			end
			
			return "The system cannot find the path specified.\n"
		end
		
		window:setCurrentDir( curPath )
		window:appendText( "\n" )
		return ""
	end
})