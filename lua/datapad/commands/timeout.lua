datapad.addCommand({
	["cmd"] = "timeout",
	["creator"] = "niksacokica",
	["description"] = "Pauses the command prompt for certain amount of time.",
	["help"] = "TIMEOUT [/T] timeout [/NOBREAK]\n\nDescription:\n" ..
		"    This utility accepts a timeout parameter to wait for the specified\n" ..
		"    time period (in seconds) or until any key is pressed. It also\n" ..
		"    accepts a parameter to ignore the key press.\n\nParameter List:\n" ..
		"    /T        timeout       Specifies the number of seconds to wait.\n" ..
		"                            Valid range is -1 to 3600 seconds.\n" ..
		"    /NOBREAK                Ignore key presses and wait specified time.\n\n" ..
		"NOTE: A timeout value of -1 means to wait indefinitely for a key press.\n" ..
		"/NOBREAK can't be the only parameter.",
	["function"] = function( args, window )
		if ( #args == 3 || #args == 4 ) and string.lower( args[2] ) == "/t" and tonumber( args[3] ) then
			local ignore = ( #args == 4 and string.upper( args[4] ) == "/NOBREAK" or false )
			
			if string.lower( args[2] ) == "/t" and tonumber( args[3] ) == -1 then
				window:SetText( window:GetText() .. "\n\nPress " .. ( ignore and "TAB" or "any key" ) .. " to continue ..." )
				window:SetCaretPos( #window:GetText() )
				window:ShouldPrint( false )
				window:Ignore( ignore )
			elseif tonumber( args[3] ) == 0 then
				return "\nWaiting for 0 seconds, press " .. ( ignore and "TAB" or "any key" ) .. " to continue ...\n"
			elseif tonumber( args[3] ) > 0 and tonumber( args[3] ) < 3601 then
				window:ShouldPrint( false )
				window:Ignore( ignore )
				
				local ogTxt = window:GetText()
				window:SetText( ogTxt .. "\n\n" .. "Waiting for " .. math.max( tonumber( args[3] ) * 1, 1 ) ..
							" seconds, press " .. ( ignore and "TAB" or "any key" ) .. " to continue ..." )
				window:SetCaretPos( #window:GetText() - ( ignore and 35 or 39 ) )
				
				timer.Create( "DatapadTimeout" .. LocalPlayer():EntIndex(), 1, math.max( tonumber( args[3] ) * 1, 1 ), function()
					if IsValid( window ) then
						window:SetText( ogTxt .. "\n\n" .. "Waiting for " ..
							math.Round( timer.RepsLeft( "DatapadTimeout" .. LocalPlayer():EntIndex() ) / 1 ) ..
							" seconds, press " .. ( ignore and "TAB" or "any key" ) .. " to continue ..." )
						
						window:SetCaretPos( #window:GetText() - ( ignore and 35 or 39 ) )
					else
						timer.Remove( "DatapadTimeout" .. LocalPlayer():EntIndex() )
					end
				end)
			end
		end
		
		return window:executeCommand( "help timeout" )
	end
})