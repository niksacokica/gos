util.AddNetworkString( "datapad_email_send" )
util.AddNetworkString( "datapad_email_new" )
util.AddNetworkString( "datapad_email_get" )
util.AddNetworkString( "datapad_email_all" )
util.AddNetworkString( "datapad_email_details" )

if not file.Exists( "datapad/emails", "DATA" ) then
	file.CreateDir( "datapad/emails" )
end

net.Receive( "datapad_email_get", function( len, ply )
	if net.ReadBool() then
		net.Start( "datapad_email_all" )
			local path = "datapad/emails/" .. ply:SteamID64()
			
			local emails = {
				["in"] = {},
				["out"] = {}
			}
			if file.Exists( path, "DATA" ) then
				files, _ = file.Find( path .. "/*.json", "DATA" )
				
				for k, v in ipairs( files ) do
					local email = util.JSONToTable( file.Read( path .. "/" .. v, "DATA" ) )
				
					table.insert( ( email["type"] == "out" ) and emails["out"] or emails["in"], { ["title"] = email["title"], ["id"] = v } )
				end
			end
			
			net.WriteTable( emails )
		net.Send( ply )
	else
		net.Start( "datapad_email_details" )
			local email = {}
			
			local path = "datapad/emails/" .. ply:SteamID64() .. "/" .. net.ReadString()
			if file.Exists( path, "DATA" ) then
				email = util.JSONToTable( file.Read( path, "DATA" ) )
			end
			
			net.WriteTable( email )
		net.Send( ply )
	end
end )

net.Receive( "datapad_email_send", function( len, ply )
	local recs = net.ReadString()
	local sender = ply:SteamID64()
	local title = net.ReadString()
	local body = net.ReadString()
	local sendTime = os.time()
	
	for k, v in ipairs( string.explode( ";", recs ) ) do
		local rec = player.GetByAccountID( v )
		if not rec then rec = player.GetBySteamID( v ) end
		if not rec then rec = player.GetBySteamID64( v ) end
		if not rec then
			for _, p in ipairs( player.GetHumans() ) do
				if v == p:Name() then
					rec = p
					break
				end
			end
		end
		
		local path = "datapad/emails/" .. ( rec and rec:SteamID64() or v )
		if not file.Exists( path, "DATA" ) then
			file.CreateDir( path )
		end
		
		local email = {
			["title"] = title,
			["body"] = body,
			["sender"] = sender,
			["receivers"] = recs,
			["time"] = sendTime,
			["type"] = "in"
		}
		
		local id = sendTime .. "_" .. title .. "_" .. sender .. ".json"
		file.Write( path .. "/" .. id , util.TableToJSON( email, true ) )
	
		if rec then
			net.Start( "datapad_email_new" )
				net.WriteString( "in" )
				net.WriteTable( { ["title"] = title, ["id"] = id } )
			net.Send( rec )
		end
	end
	
	local email = {
		["title"] = title,
		["body"] = body,
		["sender"] = sender,
		["receivers"] = recs,
		["time"] = sendTime,
		["type"] = "out"
	}
	
	local path = "datapad/emails/" .. sender
	if not file.Exists( path, "DATA" ) then
		file.CreateDir( path )
	end
	
	local id = sendTime .. "_" .. title .. ".json"
	file.Write( path .. "/" .. id , util.TableToJSON( email, true ) )
	
	net.Start( "datapad_email_new" )
		net.WriteString( "out" )
		net.WriteTable( { ["title"] = title, ["id"] = id } )
	net.Send( ply )
end )