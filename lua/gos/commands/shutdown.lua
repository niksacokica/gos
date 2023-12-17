gos:AddCommand({
	["cmd"] = "shutdown",
	["creator"] = "niksacokica",
	["description"] = "Turns off the gOS.",
	["help"] = "Usage: shutdown [/r | /a | /s] [/t xxxx]\n\n    No args    Turn off the gOS with no time-out or restart.\n" ..
		"    /r         Shutdown and restart the gOS after 1 second.\n    /a         Abort a system shutdown.\n" ..
		"               This can only be used during the time-out period.\n" ..
		"    /s         Marks the gOS for shutdown. Must be used when using /t.\n" ..
		"               Otherwise does the same thing as no arguments.\n" ..
		"    /t xxxx    Set the time-out period before shutdown to xxxx seconds.\n" ..
		"               More than one use will overwrite prevoius timers.\n" ..
		"               The valid range is 0-3600 (1 hour).\n" ..
		"               Must be used with either /r or /s.",
	["function"] = function( args, window )
		if #args == 1 then
			gos.screen:Remove()
			
			return ""
		elseif #args > 1 and #args < 6 then			
			if #args == 2 then
				if string.lower( args[2] ) == "/r" then
					if timer.Exists( gos.shutdownTimer ) then
						timer.Remove( gos.shutdownTimer )
					end
					
					gos.screen:Remove()
					
					timer.Simple( 1, function() hook.Run( "gOSShutdownRestart" ) end )
					
					return ""
				elseif string.lower( args[2] ) == "/a" then
					if timer.Exists( gos.shutdownTimer ) then
						timer.Remove( gos.shutdownTimer )
						
						return ""
					end
					
					return "Unable to abort the system shutdown because no shutdown was in progress.\n"
				elseif string.lower( args[2] ) == "/s" then
					if timer.Exists( gos.shutdownTimer ) then
						timer.Remove( gos.shutdownTimer )
					end
					
					gos.screen:Remove()
					
					return ""
				end
			elseif #args == 4 and string.StartWith( string.lower( args[3] ), "/t" ) and tonumber( args[4] ) and
				tonumber( args[4] ) > -1 and tonumber( args[4] ) < 3601 then
				if string.lower( args[2] ) == "/r" then
					timer.Create( gos.shutdownTimer, tonumber( args[4] ), 1, function()
						gos.screen:Remove()
						
						timer.Simple( 1, function() hook.Run( "gOSShutdownRestart" ) end )
					end)
				
					return ""
				elseif string.lower( args[2] ) == "/s" then
					timer.Create( gos.shutdownTimer, tonumber( args[4] ), 1, function()
						gos.screen:Remove()
					end)
					
					return ""
				end
			end
		end
		
		return window:ExecuteCommand( "help shutdown" )
	end
})