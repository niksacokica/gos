gos:AddCommand({
	["cmd"] = "color",
	["creator"] = "niksacokica",
	["description"] = "Sets the default console foreground and background colors.",
	["help"] = "COLOR [attr]\n\n  attr        Specifies color attribute of console output\n\n" ..
		"Color attributes are specified by TWO hex digits -- the first\n" ..
		"corresponds to the background; the second the foreground.  Each digit\ncan be any of the following values:\n\n" ..
		"    0 = Black       8 = Gray\n    1 = Blue        9 = Light Blue\n    2 = Green       A = Light Green\n" ..
		"    3 = Aqua        B = Light Aqua\n    4 = Red         C = Light Red\n    5 = Purple      D = Light Purple\n" ..
		"    6 = Yellow      E = Light Yellow\n    7 = White       F = Bright White\n\n" ..
		"If no argument is given, this command restores the color to what it was when command prompt started.\n" ..
		"Doesn't do anything if foreground and background color are the same value.",
	["function"] = function( args, window )
		local colors = {
			["0"] = Color(12, 12, 12),
			["1"] = Color(58, 150, 221),
			["2"] = Color(0, 128, 0),
			["3"] = Color(59, 120, 255),
			["4"] = Color(197, 15, 31),
			["5"] = Color(136, 23, 152),
			["6"] = Color(193, 156, 0),
			["7"] = Color(204, 204, 204),
			["8"] = Color(118, 118, 118),
			["9"] = Color(59, 120, 255),
			["A"] = Color(22, 198, 12),
			["B"] = Color(97, 214, 214),
			["C"] = Color(231, 72, 86),
			["D"] = Color(180, 0, 158),
			["E"] = Color(249, 241, 165),
			["F"] = Color(242, 242, 242)
		}
		
		if #args == 1 then
			window:ResetColors()
			
			return ""
		elseif #args == 2 then
			if #args[2] == 1 and colors[string.upper( args[2][1] )] then
				window:ResetColors()
				window:SetForegroundColor( colors[string.upper( args[2][1] )] )
				
				return ""
			elseif #args[2] == 2 and not ( string.upper( args[2][1] ) == string.upper( args[2][2] ) ) and
				colors[string.upper( args[2][1] )] and colors[string.upper( args[2][2] )] then
				window:SetForegroundColor( colors[string.upper( args[2][1] )] )
				window:SetBackgroundColor( colors[string.upper( args[2][2] )] )
				
				return ""
			end
		end
		
		return window:ExecuteCommand( "help color" )
	end
})