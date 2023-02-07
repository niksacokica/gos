datapad:AddApp({
	["name"] = "Command Prompt",
	["icon"] = "datapad/command_prompt.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.3, ScrH() * 0.3 )
		window:SetSize( ScrW() * 0.4, ScrH() * 0.4 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		window.title = "Command Prompt"
		window.echo = true
		window.echoString = LocalPlayer():GetName() .. ">"
		window.noDel = #window.echoString
		
		local background_color = color_black
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( background_color )
			surface.DrawRect( w * 0.001, h * 0.072, w * 0.999, h * 0.928 )
			
			surface.SetDrawColor( color_white )
			surface.DrawRect( w * 0.001, h * 0.003, w * 0.999, h * 0.07 )
			
			surface.SetFont( "DermaDefaultBold" )
			surface.SetTextColor( color_black )
			surface.SetTextPos( w * 0.05, h * 0.022 ) 
			surface.DrawText( window.title )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( Material( "datapad/command_prompt.png" ) )
			surface.DrawTexturedRect( w * 0.01, h * 0.015, w * 0.03, h * 0.05 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetText( "" )
		cls:SetPos( ScrW() * 0.3778, ScrH() * 0.001 )
		cls:SetSize( ScrW() * 0.022, ScrH() * 0.028 )
		cls.DoClick = function()
			window:Close()
		end
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( cls:IsHovered() and color_red or color_white )
			surface.DrawRect( 0, 0, w, h )
			
			draw.NoTexture()
			surface.SetDrawColor(color_black)
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, 45 )
		end		
		
		local txt = vgui.Create( "DTextEntry", window )
		txt:SetPos( 0, ScrH() * 0.029 )
		txt:SetSize( ScrW() * 0.4, ScrH() * 0.37 )
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
				if ignore and not ( kc == 67 ) then return true end
				
				if timer.Exists( "DatapadTimeout" .. LocalPlayer():EntIndex() ) then
					timer.Remove( "DatapadTimeout" .. LocalPlayer():EntIndex() )
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
			
			if ( kc == 66 and s < window.noDel + ( ( s == e || e == 0 ) and 1 or 0 ) ) || ( kc == 73 and s < window.noDel ) then
				if not ( s == e ) and not ( e == 0 ) then
					txt:SetText( curTxt )
					txt:SetCaretPos( window.noDel )
				end
				
				return true
			elseif kc == 64 then
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
			elseif kc == 88 then
				if hPos > 1 then
					hPos = hPos - 1
				end
				
				if history then
					txt:SetText( curTxt .. history[hPos] )
					txt:SetCaretPos( string.len( txt:GetText() ) )
				end
				
				return true
			elseif kc == 90 then
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
			self.echoString = LocalPlayer():GetName() .. ">" 
		end
		function window:GetEchoString()
			return self.echoString
		end
		function window:ExecuteCommand( cmd )
			local ex = datapad:ExecuteCommand( cmd, self )
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
	end
})