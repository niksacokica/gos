util.AddNetworkString( "gos_email_send" )
util.AddNetworkString( "gos_email_new" )
util.AddNetworkString( "gos_email_get" )
util.AddNetworkString( "gos_email_all" )
util.AddNetworkString( "gos_email_details" )

if not file.Exists( "gos/emails", "DATA" ) then
	file.CreateDir( "gos/emails" )
end

net.Receive( "gos_email_get", function( len, ply )
	if net.ReadBool() then
		net.Start( "gos_email_all" )
			local path = "gos/emails/" .. ply:SteamID64()
			
			local emails = {
				["in"] = {},
				["out"] = {}
			}
			if file.Exists( path, "DATA" ) then
				files, _ = file.Find( path .. "/*.json", "DATA" )
				
				for k, v in ipairs( files ) do
					local email = util.JSONToTable( file.Read( path .. "/" .. v, "DATA" ) )
				
					if email then
						table.insert( ( email["type"] == "out" ) and emails["out"] or emails["in"], { ["title"] = email["title"], ["id"] = v, ["send_rec"] = ( email["type"] == "out" and email["recipients"] or email["sender_name"] ), ["time"] = email["time"] } )
					else
						print( v .. " is corrupted!" )
					end
				end
			end
			
			net.WriteTable( emails )
		net.Send( ply )
	else
		net.Start( "gos_email_details" )
			local email
			
			local path = "gos/emails/" .. ply:SteamID64() .. "/" .. net.ReadString()
			if file.Exists( path, "DATA" ) then
				email = file.Read( path, "DATA" )
			end
			
			local sendData = util.Compress( email )
			net.WriteData( sendData, #sendData )
		net.Send( ply )
	end
end )

net.Receive( "gos_email_send", function( len, ply )
	local recs = net.ReadString()
	local sender = ply:SteamID64()
	local sender_name = ply:Nick()
	local title = net.ReadString()
	local body = net.ReadString()
	local sendTime = os.time()
	
	for k, v in ipairs( string.Explode( ";", recs ) ) do
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
		
		local path = "gos/emails/" .. ( rec and rec:SteamID64() or v )
		if not file.Exists( path, "DATA" ) then
			file.CreateDir( path )
		end
		
		local email = {
			["title"] = title,
			["body"] = body,
			["sender"] = sender,
			["sender_name"] = sender_name,
			["recipients"] = recs,
			["time"] = sendTime,
			["type"] = "in"
		}
		
		local id = sendTime .. "_" .. title .. "_" .. sender .. ".json"
		file.Write( path .. "/" .. id , util.TableToJSON( email, true ) )
	
		if rec then
			net.Start( "gos_email_new" )
				net.WriteString( "in" )
				net.WriteTable( { ["title"] = title, ["id"] = id, ["send_rec"] = sender_name, ["time"] = sendTime } )
			net.Send( rec )
		end
	end
	
	local email = {
		["title"] = title,
		["body"] = body,
		["sender"] = sender,
		["sender_name"] = sender_name,
		["recipients"] = recs,
		["time"] = sendTime,
		["type"] = "out"
	}
	
	local path = "gos/emails/" .. sender
	if not file.Exists( path, "DATA" ) then
		file.CreateDir( path )
	end
	
	PrintTable(email)
	
	local id = sendTime .. "_" .. title .. ".json"
	file.Write( path .. "/" .. id , util.TableToJSON( email, true ) )
	
	net.Start( "gos_email_new" )
		net.WriteString( "out" )
		net.WriteTable( { ["title"] = title, ["id"] = id, ["send_rec"] = recs, ["time"] = sendTime } )
	net.Send( ply )
end )