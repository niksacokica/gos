gos:AddCommand({
	["cmd"] = "hostname",
	["creator"] = "niksacokica",
	["description"] = "Prints the name of the current host.",
	["help"] = "HOSTNAME",
	["function"] = function( args, window )
		local hostname = ""
	
		steamworks.RequestPlayerInfo( LocalPlayer():SteamID64(), function( steamName )
			hostname = steamName
		end )
		
		return hostname .. "\n"
	end
})