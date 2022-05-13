datapad.addCommand({
	["cmd"] = "prompt",
	["creator"] = "niksacokica",
	["description"] = "Changes the command prompt.",
	["help"] = "PROMPT [text]\n\n  text    Specifies a new command prompt.",
	["function"] = function( args, window )
		if #args == 1 then
			window.echoString = LocalPlayer():GetName() .. ">"
		else
			window.echoString = table.concat( args, " ", 2 )
		end
		
		return ""
	end
})