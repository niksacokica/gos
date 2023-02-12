datapad:AddCommand({
	["cmd"] = "title",
	["creator"] = "niksacokica",
	["description"] = "Sets the window title for this session.",
	["help"] = "TITLE [string]\n\n  string       Specifies the title for the command prompt window.",
	["function"] = function( args, window )
		if #args == 1 then return window:ExecuteCommand( "help title" ) end
		
		window:SetWindowTitle( table.concat( args, " ", 2 ) )
		
		return ""
	end
})