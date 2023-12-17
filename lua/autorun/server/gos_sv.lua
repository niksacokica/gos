gos = istable( gos ) and gos or {}
gos.devMode = false

local _, directories = file.Find( "gos/*", "LUA" )

for _, dir in ipairs( directories ) do
	files, _ = file.Find( "gos/" .. dir .. "/*.lua", "LUA" )
	for _, v in ipairs( files ) do
		AddCSLuaFile( "gos/" .. dir .. "/" .. v )
	end
end

util.AddNetworkString( "gos_open" )
util.AddNetworkString( "gos_ply_first" )
util.AddNetworkString( "gos_get_dev" )
util.AddNetworkString( "gos_set_dev" )
util.AddNetworkString( "gos_ply_death" )

local function sendDev( ply, first )
	net.Start( "gos_get_dev" )
		net.WriteBool( gos.devMode )
		net.WriteBool( first )
	net.Send( ply )
end

net.Receive( "gos_ply_first", function( len, ply )
	sendDev( ply, true )
end )

net.Receive( "gos_set_dev", function()
	gos.devMode = net.ReadBool()

	sendDev( player.GetHumans(), false )
end )

hook.Add( "PlayerDeath", "gOSPlayerDeath", function( victim )
	net.Start( "gos_ply_death" )
	net.Send( victim )
end )