gos:AddApp({
	["name"] = "Command Prompt",
	["icon"] = "gos/app_icons/command_prompt.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.5 - 512, ScrH() * 0.5 - 256 )
		window:SetSize( 1024, 512 )
		window:ShowCloseButton( false )
		window:SetSizable( true )
		window:SetMinWidth( 256 )
		window:SetMinHeight( 128 )
		window:SetTitle( "" )
		window.title = "Command Prompt"
		window.curDir = "personal_files"
		
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35)
		function window:getCurrentDir()
			local str, _ = string.gsub( window:getTrueCurrentDir(), "personal_files", LocalPlayer():GetName(), 1 )
			return str
		end
		function window:getTrueCurrentDir()
			return window.curDir
		end
		function window:setCurrentDir( dir )
			local tmp = window:getCurrentDir()
			window.curDir = dir
			
			if string.StartsWith( window.echoString, tmp ) then
				window.echoString = window:getCurrentDir() .. ">"
			end
		end
		
		window.echo = true
		window.echoString = window:getCurrentDir() .. ">"
		window.noDel = #window.echoString
		
		local background_color = color_black
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( color_white )
			surface.DrawRect( 1, 1, w - 2, 30 )
			
			surface.SetDrawColor( background_color )
			surface.DrawRect( 1, 31, w - 2, h - 32 )
			
			surface.SetFont( "DermaDefaultBold" )
			surface.SetTextColor( color_black )
			surface.SetTextPos( 50, 10 ) 
			surface.DrawText( window.title )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( Material( "gos/app_icons/command_prompt.png" ) )
			surface.DrawTexturedRect( 5, 0, 34, 34 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetPos( 973, 1 )
		cls:SetSize( 50, 30 )
		cls.DoClick = function()
			window:Close()
		end
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and color_red or color_white )
			surface.DrawRect( 0, 0, w, h )
			
			draw.NoTexture()
			surface.SetDrawColor(color_black)
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, 2, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, 2, h * 0.5, 45 )
			
			return true
		end		
		
		local txt = vgui.Create( "DTextEntry", window )
		txt:SetPos( 1, 31 )
		txt:SetSize( 1022, 480 )
		txt:SetVerticalScrollbarEnabled( true )
		txt:SetPaintBackground( false )
		txt:SetDrawLanguageID( false )
		txt:SetTabbingDisabled( true )
		txt:SetHistoryEnabled( true )
		txt:SetMultiline( true )
		
		txt:SetCursorColor( color_gray )
		txt:SetTextColor( color_gray )
		txt:SetFont( "BudgetLabel" )
		txt:SetText( window.echoString )
		
		txt.OnMousePressed = function( self, kc )
			if kc == MOUSE_RIGHT then return true end
		end
		
		window.OnSizeChanged = function( self, newW, newH )
			cls:SetX( newW - 51 )
			txt:SetSize( newW - 2, newH - 32 )
		end
		
		local history = {}
		local hPos = 0
		local curTxt = window.echoString
		local pressToContinue = false
		local pressToContinueChar = false
		local ignore = false
		txt.AllowInput = function( self, stringValue )		
			if pressToContinueChar then
				if ignore then return true end
			
				pressToContinueChar = false
				return true
			end
			
			local s, e = txt:GetSelectedTextRange()
			s = ( s == 0 || s == e ) and txt:GetCaretPos() or s
			if s < window.noDel then
				txt:SetText( curTxt )
				txt:SetCaretPos( window.noDel )
			end
		end
		txt.OnKeyCodeTyped = function( self, kc )
			if pressToContinue then
				if ignore and not ( kc == KEY_TAB ) then return true end
				
				if timer.Exists( "gOSTimeout" .. LocalPlayer():EntIndex() ) then
					timer.Remove( "gOSTimeout" .. LocalPlayer():EntIndex() )
				end
				
				txt:SetText( txt:GetText() .. "\n\n" .. ( window.echo and window.echoString or "" ) )
				window.noDel = #txt:GetText()
				txt:SetCaretPos( window.noDel )
				curTxt = txt:GetText()
				
				pressToContinue = false
				ignore = false
				return true
			end
		
			local s, e = txt:GetSelectedTextRange()
			s = ( s == 0 || s == e ) and txt:GetCaretPos() or s
			
			if ( kc == KEY_BACKSPACE and s < window.noDel + ( ( s == e || e == 0 ) and 1 or 0 ) ) || ( kc == KEY_DELETE and s < window.noDel ) then
				if not ( s == e ) and not ( e == 0 ) then
					txt:SetText( curTxt )
					txt:SetCaretPos( window.noDel )
				end
				
				return true
			elseif kc == KEY_ENTER then
				local text = txt:GetText()
				local command = string.sub( text, window.noDel + 1)
				
				hPos = #history
				if not ( history[#history] == command ) then
					table.insert( history, command )
					hPos = #history + 1
				end
				
				if #command > 0 then
					window:ExecuteCommand( command )
				end
				
				return true
			elseif kc == KEY_UP then
				if hPos > 1 then
					hPos = hPos - 1
				end
				
				if #history > 0 then
					txt:SetText( curTxt .. history[hPos] )
					txt:SetCaretPos( string.len( txt:GetText() ) )
				end
				
				return true
			elseif kc == KEY_DOWN then
				if hPos < #history then
					hPos = hPos + 1
					
					txt:SetText( curTxt .. history[hPos] )
					txt:SetCaretPos( string.len( txt:GetText() ) )
				elseif hPos == #history then
					hPos = hPos + 1
					
					txt:SetText( curTxt )
					txt:SetCaretPos( window.noDel )
				end
				
				return true
			end
		end
		
		function window:GetText()
			return txt:GetText()
		end
		function window:ResetText()
			txt:SetText( "" )
		end
		function window:GetCaretPos()
			return txt:GetCaretPos()
		end
		function window:SetCaretPos( pos )
			txt:SetCaretPos( pos )
		end
		function window:ResetColors()
			background_color = color_black
			txt:SetCursorColor( color_gray )
			txt:SetTextColor( color_gray )
		end
		function window:SetForegroundColor( clr )
			txt:SetCursorColor( clr )
			txt:SetTextColor( clr )
		end
		function window:SetBackgroundColor( clr )
			background_color = clr
		end
		function window:SetWindowTitle( str )
			self.title = str
		end
		function window:GetWindowTitle()
			return self.title
		end
		function window:ShouldPrint( bool )
			pressToContinue = not bool
			pressToContinueChar = not bool
		end
		function window:Ignore( bool )
			ignore = bool
		end
		function window:SetEcho( bool )
			self.echo = bool
		end
		function window:GetEcho()
			return self.echo
		end
		function window:SetEchoString( str )
			self.echoString = str
		end
		function window:ResetEchoString()
			self.echoString = window:getCurrentDir() .. ">" 
		end
		function window:GetEchoString()
			return self.echoString
		end
		function window:ExecuteCommand( cmd )
			local ex = gos:ExecuteCommand( cmd, self )
			if ex == nil then return end
			ex = tostring( ex )
			
			if not pressToContinue then
				txt:SetText( txt:GetText() .. "\n" .. ( #ex > 0 and ex .. "\n" or ex ) .. ( self.echo and window.echoString or "" ) )
				self.noDel = #txt:GetText()
				txt:SetCaretPos( self.noDel )
				curTxt = txt:GetText()
			end
		end
		function window:appendText( text )
			txt:SetText( txt:GetText() .. text )
			self.noDel = #txt:GetText()
			txt:SetCaretPos( self.noDel )
			curTxt = txt:GetText()
		end
		function window:removeText( charNum )
			txt:SetText( string.Left( txt:GetText(), #txt:GetText() - charNum ) )
			self.noDel = #txt:GetText()
			txt:SetCaretPos( self.noDel )
			curTxt = txt:GetText()
		end
	end
})

function gos:AddCommand( cmd )
	self.cmds = istable( self.cmds ) and self.cmds or {}
	
	local cl = string.lower( cmd["cmd"] )
	if #cmd["cmd"] == 0 then
		return
	elseif istable( self.cmds[cl] ) and not gos.devMode then
		ErrorNoHalt( "Command with the name '" .. cl .. "' already exists!" )
	elseif #cl > 14 then
		ErrorNoHalt( "Command name '" .. cl .. "' is too long, max length is 14 characters!" )
	else
		self.cmds[cl] = cmd
	end
end

function gos:ExecuteCommand( cmd, window )
	local cAf = string.Explode( " ", cmd )
	for i=#cAf, 1, -1 do
		if #cAf[i] == 0 then
			table.remove( cAf, i )
		end
	end
	cAf[1] = string.lower( cAf[1] )
	
	if string.EndsWith( cAf[#cAf], ".lua" ) then
		cAf[#cAf] = string.StripExtension( cAf[#cAf] )
		table.insert( cAf, 1, "start" )
	end
	
	if istable( self.cmds[cAf[1]] ) then return self.cmds[cAf[1]]["function"]( cAf, window ) end
	
	return "'" .. cAf[1] .. "' is not recognized as a command!\n"
end