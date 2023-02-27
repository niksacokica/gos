datapad = istable( datapad ) and datapad or {}
datapad.devMode = false

local files, directories = file.Find( "datapad/*", "LUA" )

for _, dir in ipairs( directories ) do
	files, directories = file.Find( "datapad/" .. dir .. "/*.lua", "LUA" )
	for _, v in ipairs( files ) do
		AddCSLuaFile( "datapad/" .. dir .. "/" .. v )
	end
end

util.AddNetworkString( "datapad_open" )
util.AddNetworkString( "datapad_ply_first" )
util.AddNetworkString( "datapad_get_dev" )
util.AddNetworkString( "datapad_set_dev" )

local function sendDev( ply, first )
	net.Start( "datapad_get_dev" )
		net.WriteBool( datapad.devMode )
		net.WriteBool( first )
	net.Send( ply )
end

net.Receive( "datapad_ply_first", function( len, ply )
	sendDev( ply, true )
end )

net.Receive( "datapad_set_dev", function()
	datapad.devMode = net.ReadBool()

	sendDev( player.GetHumans(), false )
end )