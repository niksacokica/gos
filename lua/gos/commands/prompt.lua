gos:AddCommand({
	["cmd"] = "prompt",
	["creator"] = "niksacokica",
	["description"] = "Changes the command prompt.",
	["help"] = "PROMPT [text]\n\n  text    Specifies a new command prompt.",
	["function"] = function( args, window )
		if #args == 1 then
			window:ResetEchoString()
		else
			window:SetEchoString( table.concat( args, " ", 2 ) )
		end
		
		return ""
	end
})