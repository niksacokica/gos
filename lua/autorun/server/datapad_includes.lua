local files, directories = file.Find( "datapad/*", "LUA" )

for _, dir in ipairs( directories ) do
	if not ( dir == "apps" ) and not ( dir == "commands" ) then continue end

	files, directories = file.Find( "datapad/" .. dir .. "/*.lua", "LUA" )
	for _, v in ipairs( files ) do
		AddCSLuaFile( "datapad/" .. dir .. "/" .. v )
	end
end