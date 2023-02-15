datapad:AddCommand({
	["cmd"] = "dir",
	["creator"] = "niksacokica",
	["description"] = "List directory contents.",
	["help"] = "DIR [path] [/B] [/C] [/D] [/L] [/O[[:]sortorder]] [/S] [/W]\n\n" ..
		"  [path]     Specifies directory to list.\n" ..
		"  [/B]       Uses bare format (no heading information or summary).\n" ..
		"  [/C]       Display the file size with the thousand separator.\n" ..
		"  [/L]       Uses uppercase.\n" ..
		"  [/O]       List files in sorted order.\n" ..
		"  sortorder  N  By name (alphabetic)       S  By size (smallest first)\n" ..
		"             E  By extension (alphabetic)  D  By date/time (oldest first)\n" ..
		"             -  Prefix to reverse order\n" ..
		"  [/S]       Displays files in specified directory and all subdirectories.",
	["function"] = function( args, window )	
		table.remove( args, 1 )
		
		local flags = {
			["path"] = "",
			["/B"] = false,
			["/C"] = false,
			["/L"] = false,
			["/O"] = "",
			["/S"] = false
		}
		local validSorts = {
			["N"] = true,
			["S"] = true,
			["E"] = true,
			["D"] = true,
			["-N"] = true,
			["-S"] = true,
			["-E"] = true,
			["-D"] = true
		}
		
		for k, v in ipairs( args ) do
			v = string.upper( v )
			if string.StartsWith( v, "/O" ) and #v > 3 then
				local sort = string.sub( v, 4, 5 )
				
				if not validSorts[sort] then return window:ExecuteCommand( "help dir" ) end
			
				flags["/O"] = sort
			elseif not ( flags[v] == nil ) then
				flags[v] = true
			elseif not string.StartsWith( v, "/" ) then
				flags["path"] = flags["path"] .. ( #flags["path"] > 0 and " " or "" ) .. string.lower( v )
			end
		end
		
		local function getData( path, parentData )		
			local files, dirs = file.Find( path .. "*", "DATA" )
			table.Add( files, dirs )
			table.sort( files )
			
			local data = {}
			if parentData and not table.IsEmpty( parentData ) then
				parentData["name"] = ".."
				table.insert( data, parentData )
			end
			
			local allFilesSizes = 0
			for k, v in ipairs( files ) do
				local f = path .. v
				
				local fileSize = file.Size( f, "DATA" )
				local isDir = file.IsDir( f, "DATA" )
				
				allFilesSizes = allFilesSizes + ( isDir and 0 or fileSize )
				
				table.insert( data, {
					["date"] = os.date( "%d.%m.%Y.  %H:%M", file.Time( f, "DATA" )  ),
					["dir"] = isDir,
					["size"] = flags["/C"] and string.Comma( fileSize, "." ) or fileSize,
					["name"] = flags["/L"] and string.upper( v ) or v
				})
			end

			local localPath = LocalPlayer():GetName() .. string.Right( path, #path - 22 )
			return { ["path"] = flags["/L"] and string.upper( localPath ) or localPath, ["data"] = data, ["numFiles"] = #files - #dirs, ["numDirs"] = #dirs + ( parentData and 1 or 0 ), ["totalFileSize"] = allFilesSizes }
		end
		
		if #flags["path"] > 0 then
			local ret = " Directory of " .. window:getCurrentDir() .. "/\n"
			local cd = datapad:ExecuteCommand( "cd " .. flags["path"], window )
		
			if cd == "The system cannot find the path specified.\n" then
				return ret .. "\n" .. cd
			end
		end
		
		local data = {}
		local mainPath = "datapad/" .. window:getTrueCurrentDir() .. "/"		
		local paths = string.Explode( "/", mainPath )
		local tempPath = table.concat( paths, "/", 1, math.max( #paths - 1, 1 ) )
		local fileSize = file.Size( tempPath, "DATA" )
		local parentData = {
			["date"] = os.date( "%d.%m.%Y.  %H:%M", file.Time( tempPath, "DATA" )  ),
			["dir"] = file.IsDir( tempPath, "DATA" ),
			["size"] = flags["/C"] and string.Comma( fileSize, "." ) or fileSize,
			["name"] = flags["/L"] and string.upper( tempPath ) or tempPath
		}
		
		table.insert( data, getData( mainPath, not ( window:getTrueCurrentDir() == "personal_files" ) and parentData or {} ) )
		if flags["/S"] then
			local function goDeep( path, parentData )
				local _, dirs = file.Find( path ..  "*", "DATA" )
				
				for k, v in ipairs( dirs ) do				
					local curData = getData( mainPath .. v .. "/", parentData )
					table.insert( data, curData )
					goDeep( v, curData["data"] )
				end
			end
		
			goDeep( mainPath, parentData )
		end
		
		if #flags["path"] > 0 then
			local paths = string.Explode( "[/\\]+", flags["path"], true )
			for k, v in ipairs( paths ) do
				if v == "" then
					table.remove( paths, k )
				end
			end
			
			datapad:ExecuteCommand( "cd " .. string.rep( "..", #paths, "/" ), window )
			window:removeText( 2 )
		end
		
		if #flags["/O"] > 0 then
			for k, v in ipairs( data ) do
				table.sort( v["data"], function(a, b)
					local rev = ( #flags["/O"] == 2 and flags["/O"][1] == "-" )
					local sort = ( #flags["/O"] == 2 and flags["/O"][2] or flags["/O"][1] )
				
					local comp1 = false
					local comp2 = false
					if sort == "N" then
						comp1 = a["name"] > b["name"]
						comp2 = a["name"] < b["name"]
					elseif sort == "S" then
						comp1 = a["size"] > b["size"]
						comp2 = a["size"] < b["size"]
					elseif sort == "E" then
						local extA = string.GetExtensionFromFilename( a["name"] ) or ""
						local extB = string.GetExtensionFromFilename( b["name"] ) or ""
					
						comp1 = extA > extB
						comp2 = extA < extB
					elseif sort == "D" then
						comp1 = a["date"] > b["date"]
						comp2 = a["date"] < b["date"]
					end
					
					if rev then return comp1 else return comp2 end
				end )
			end
		end
		
		local toPrint = ""
		if flags["/B"] then
			for k, v in ipairs( data ) do
				for i, p in ipairs( v["data"] ) do
					if not ( p["name"] == ".." ) then
						toPrint = toPrint .. ( flags["/S"] and v["path"] or "" ) .. p["name"] .. "\n"
					end
				end
			end
		else
			for k, v in ipairs( data ) do
				toPrint = toPrint .. " Directory of " .. v["path"] .. "\n"
				
				local maxSize = "0"
				for _, s in ipairs( v["data"] ) do
					if tostring( s["size"] ) > maxSize then maxSize = tostring( s["size"] ) end
				end
				
				for i, p in ipairs( v["data"] ) do
					toPrint = toPrint .. "\n" .. p["date"] .. ( p["dir"] and "    <DIR>" or "         " )
					toPrint = toPrint .. string.rep( " ", string.len( tostring( maxSize ) ) - string.len( tostring( p["size"] ) ) )
					toPrint = toPrint .. ( p["dir"] and " " or p["size"] ) .. " " .. p["name"]
				end
				
				toPrint = toPrint .. "\n" .. string.rep( " ", 14 ) .. v["numFiles"] .. " File(s)  " ..  v["totalFileSize"] .. " bytes"
				toPrint = toPrint .. "\n" .. string.rep( " ", 14 ) .. v["numDirs"] .. " Dir(s)\n\n"
				
				if not flags["/S"] then continue end
			end
		end
		
		return string.sub( toPrint, 1, #toPrint - 1 )
	end
})