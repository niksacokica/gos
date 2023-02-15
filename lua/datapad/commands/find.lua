datapad:AddCommand({
	["cmd"] = "find",
	["creator"] = "niksacokica",
	["description"] = "Searches for a text string in a file.",
	["help"] = "FIND [/V] [/C] [/N] [/I] \"string\" [path]filename\n\n" ..
		"  /V               Displays all lines NOT containing the specified string.\n" ..
		"  /C               Displays only the count of lines containing the string.\n" ..
		"  /N               Displays line numbers with the displayed lines.\n" ..
		"  /I               Ignores the case of characters when searching for the string.\n" ..
		"  \"string\"       Specifies the text string to find.\n" ..
		"  [path]filename   Specifies a file to search.",
	["function"] = function( args, window )
		table.remove( args, 1 )
		local flags = {
			["path"] = "",
			["string"] = "",
			["/V"] = false,
			["/C"] = false,
			["/N"] = false,
			["/I"] = false
		}
		
		local nameGet = false
		for k, v in ipairs( args ) do
			local str = string.upper( v )
			if not ( flags[str] == nil ) then
				flags[str] = true
			elseif string.StartsWith( str, "\"" ) or nameGet then
				nameGet = true
				flags["string"] = flags["string"].. ( #flags["string"] > 0 and " " or "" ) .. v
				
				if string.EndsWith( str, "\"" ) then
					nameGet = false
				end
			else
				flags["path"] = flags["path"] .. ( #flags["path"] > 0 and " " or "" ) .. string.lower( str )
			end
		end
		
		local fullPath = "datapad/" .. window:getTrueCurrentDir() .. "/" .. flags["path"]
		flags["string"] =  string.sub( ( flags["/I"] and string.lower( flags["string"] ) or flags["string"] ), 2, -2 )
		
		if #flags["path"] == 0 then return "FIND: Parameter format not correct\n"
		elseif not file.Exists( fullPath, "DATA" ) then return "File not found - " .. flags["path"] .. "\n" end
	
		local result = {}
		local lineNum = 1
		local f = file.Open( fullPath, "r", "DATA" )
			while( not f:EndOfFile() ) do
				local line = f:ReadLine()
				line = ( flags["/I"] and string.lower( line ) or line )
				
				local sPos = string.find( line, flags["string"] )
				if ( flags["/V"] and sPos == nil ) or ( not flags["/V"] and not ( sPos == nil ) ) then
					result[lineNum] = line
				end
				
				lineNum = lineNum + 1
			end
		f:Close()
		
		local toPrint = "\n---------- " .. string.GetFileFromFilename( fullPath )
		if flags["/C"] then
			toPrint = toPrint .. ": " .. #result .. "\n"
		else
			toPrint = toPrint .. "\n"
			for k, v in pairs( result ) do
				toPrint = toPrint .. ( flags["/N"] and "[" .. k .. "]" or "" ) .. v
			end
		end
	
		return toPrint
	end
})