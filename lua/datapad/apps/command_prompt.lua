datapad.addApp({
	["name"] = "Command Prompt",
	["icon"] = "datapad/command_prompt.png",
	["creator"] = "niksacokica",
	["window"] = function( background )
		local cmd = vgui.Create( "DFrame" )
		cmd:SetPos( ScrW() * 0.3, ScrH() * 0.3 )
		cmd:SetSize( ScrW() * 0.4, ScrH() * 0.4 )
		cmd:SetTitle( "" )
		cmd:ShowCloseButton( false )
		cmd:MakePopup()
		
		cmd.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( color_black )
			surface.DrawRect( w * 0.002, h * 0.074, w * 0.998, h * 0.926 )
			
			surface.SetDrawColor( color_white )
			surface.DrawRect( w * 0.002, h * 0.003, w * 0.998, h * 0.07 )
			
			surface.SetFont( "DermaDefaultBold" )
			surface.SetTextColor( color_black )
			surface.SetTextPos( w * 0.05, h * 0.022 ) 
			surface.DrawText( "Command Prompt" )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( Material( "datapad/command_prompt.png" ) )
			surface.DrawTexturedRect( w * 0.01, h * 0.015, w * 0.03, h * 0.05 )
		end
		
		local cls = vgui.Create( "DButton", cmd )
		cls:SetText( "" )
		cls:SetPos( ScrW() * 0.3777, ScrH() * 0.001 )
		cls:SetSize( ScrW() * 0.022, ScrH() * 0.028 )
		cls.DoClick = function()
			cmd:Close()
		end
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( cls:IsHovered() and color_red or color_white )
			surface.DrawRect( 0, 0, w, h )
			
			surface.SetDrawColor( color_black )
			surface.DrawLine( w * 0.4, h * 0.35, w * 0.6, h * 0.65 )
			surface.DrawLine( w * 0.4, h * 0.65, w * 0.6, h * 0.35 )
			surface.DrawLine( w * 0.41, h * 0.351, w * 0.61, h * 0.651 )
			surface.DrawLine( w * 0.41, h * 0.651, w * 0.61, h * 0.351 )
		end
		
		local txt = vgui.Create( "DTextEntry", cmd )
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
		txt:SetText( LocalPlayer():GetName() .. ">" )
		
		txt.OnMousePressed = function( self, kc )
			if kc == MOUSE_RIGHT then return true end
		end
		
		local noDel = 13
		local history = {}
		local hPos = 0
		local curTxt = ""
		txt.OnKeyCodeTyped = function( self, kc )
			local s, e = txt:GetSelectedTextRange()
			s = ( s == 0 || s == e ) and txt:GetCaretPos() or s
			
			if ( kc == 66 and s < noDel + ( ( s == e || e == 0 ) and 1 or 0 ) ) || ( kc == 73 and s < noDel ) then
				if not ( s == e ) and not ( e == 0 ) then
					txt:SetText( ( #curTxt and curTxt .. "\n" ) .. LocalPlayer():GetName() .. ">" )
					txt:SetCaretPos( noDel )
				end
				
				return true
			elseif kc == 64 then
				local text = txt:GetText()
				local strLen = #text
				local command = string.sub( text, ( noDel == 13 and noDel or noDel + 1 ) )
				noDel = strLen + 13
				
				if not ( history[#history] == command ) then
					table.insert( history, command )
					hPos = #history + 1
				end
				
				local ret = ""
				if #command > 0 then
					local ec = datapad.executeCommand( command )
					ret = ( #ec > 0 ) and ec .. "\n" or ec
				end
				
				txt:SetText( text .. "\n" .. ret .. LocalPlayer():GetName() .. ">" )
				noDel = #txt:GetText()
				txt:SetCaretPos( noDel )
				curTxt = txt:GetText()
				
				return true
			elseif kc == 88 then
				if hPos > 1 then
					hPos = hPos - 1
				end
				
				txt:SetText( curTxt .. history[hPos] )
				txt:SetCaretPos( string.len( txt:GetText() ) )
				
				return true
			elseif kc == 90 then
				if hPos < #history then
					hPos = hPos + 1
					
					txt:SetText( curTxt .. history[hPos] )
					txt:SetCaretPos( string.len( txt:GetText() ) )
				elseif hPos == #history then
					hPos = hPos + 1
					
					txt:SetText( curTxt )
					txt:SetCaretPos( noDel )
				end
				
				return true
			end
		end
		
		return cmd
	end
})