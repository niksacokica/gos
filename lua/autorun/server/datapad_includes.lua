local files, directories = file.Find( "datapad/*", "LUA" )

for _, d in ipairs( directories ) do
	if not ( d == "apps" ) and not ( d == "commands" ) then continue end

	files, directories = file.Find( "datapad/" .. d .. "/*.lua", "LUA" )
	for _, v in ipairs( files ) do
		AddCSLuaFile( "datapad/" .. d .. "/" .. v )
	end
end