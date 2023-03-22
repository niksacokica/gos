util.AddNetworkString( "datapad_email_send" )
util.AddNetworkString( "datapad_email_new" )
util.AddNetworkString( "datapad_email_get" )
util.AddNetworkString( "datapad_email_all" )

if not file.Exists( "datapad/emails", "DATA" ) then
	file.CreateDir( "datapad/emails" )
end

net.Receive( "datapad_email_get", function( len, ply )
	if net.ReadBool() then
		net.Start( "datapad_email_all" )
			local path = "datapad/emails/" .. ply:SteamID64()
			
			local emails = {}
			if file.Exists( path, "DATA" ) then
				files, _ = file.Find( path .. "/*.json", "DATA" )
				
				for k, v in ipairs( files ) do
					local email = util.JSONToTable( file.Read( path .. "/" .. v, "DATA" ) )
				
					table.insert( emails, email["title"] )
				end
			end
			
			net.WriteTable( emails )
		net.Send( ply )
	else
	end
end )

 -- need to write to sender also
net.Receive( "datapad_email_send", function( len, ply )
	local recs = string.explode( ";", net.ReadString() )
	local sender = ply:SteamID64()
	local title = net.ReadString()
	local body = net.ReadString()
	
	for k, v in ipairs( recs ) do
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
		if not rec then continue end
		
		local path = "datapad/emails/" .. sender
		if not file.Exists( path, "DATA" ) then
			file.CreateDir( path )
		end
		
		local email = {
			["title"] = title,
			["body"] = body,
			["sender"] = sender,
			["type"] = "in"
		}
		
		file.Write( path .. "/" .. os.time() .. "_" .. title .. "_" .. sender .. ".json" , util.TableToJSON( email, true ) )
	
		--need to fix notification
		net.Start( "datapad_email_new" )
			net.WriteString( title )
		net.Send( rec )
	end
end )