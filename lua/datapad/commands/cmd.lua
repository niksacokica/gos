datapad.addCommand({
	["cmd"] = "cmd",
	["creator"] = "niksacokica",
	["description"] = "Starts a new instance of the command prompt.",
	["help"] = "CMD [/Q] [/T:{<f><b> | <f>}] [[/C | /K] string]\n\nNo args                Starts the new command prompt\n" ..
		"/Q                     Turns echo off\n" ..
		"/T:{<f><b> | <f>}      Sets the foreground/background colors (see HELP COLOR for more info)\n" ..
		"/C                     Carries out the command specified by string and then terminates\n" ..
		"/K                     Carries out the command specified by string but remains\n\n" ..
		"Note that multiple commands separated by the '&&' are accepted for string.\n\n" ..
		"If /C or /K is specified, then they must be at the end.",
	["function"] = function( args, window )		
		local qIsSet = false
		local tIsSet = ""
		local cIsSet = false
		local kIsSet = false
		local ckKey = 0
		
		for i=2, #args do
			ckKey = i + 1
			
			if string.upper( args[i] ) == "/C" and #args > i then
				cIsSet = true
				
				break
			elseif string.upper( args[i] ) == "/K" and #args > i then
				kIsSet = true
				
				break
			elseif string.StartWith( string.upper( args[i] ), "/T:" ) and ( #args[i] == 4 || #args[i] == 5 ) and #tIsSet == 0 then
				tIsSet = string.Right( args[i], #args[i] - 3 )
				
				if ( #tIsSet == 2 and string.upper( tIsSet[1] ) == string.upper( tIsSet[2] ) ) ||
					not string.match( string.upper( tIsSet ), "^[0-9A-F]+$", 1 ) then
					return window:executeCommand( "help cmd" )
				end
			elseif string.upper( args[i] ) == "/Q" and not qIsSet then
				qIsSet = true
			else
				return window:executeCommand( "help cmd" )
			end
		end
		
		local newApp = datapad.startApp( datapad.apps["Command Prompt"] )
		if qIsSet then
			newApp.noDel = 0
			newApp:SetEcho( false )
			
			newApp:executeCommand( "cls" )
		end
		if #tIsSet > 0 then
			newApp:appendText( "color " .. tIsSet )
			newApp:executeCommand( "color " .. tIsSet )
			newApp:executeCommand( "cls" )
		end
		if cIsSet || kIsSet then
			local str = table.concat( args, " ", ckKey )
			print(str)
			
			if cIsSet then
				newApp:executeCommand( "exit" )
			end
		end
		
		return ""
	end
})