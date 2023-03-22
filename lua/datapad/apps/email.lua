datapad:AddApp({
	["name"] = "Email",
	["icon"] = "datapad/app_icons/email.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local back_clr = Color( 50, 50, 50 )
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35)
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( w * 0.0015, h * 0.002, w * 0.9985, h * 0.998 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetText( "" )
		cls:SetPos( ScrW() * 0.478, ScrH() * 0.001 )
		cls:SetSize( ScrW() * 0.022, ScrH() * 0.028 )
		cls.DoClick = function()
			window:Close()
		end
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( cls:IsHovered() and color_red or back_clr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.NoTexture()
			surface.SetDrawColor( color_white )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, 45 )
		end
		
		local emails = vgui.Create( "DScrollPanel", window )
		emails:SetPos( ScrW() * 0.01, ScrH() * 0.056 )
		emails:SetSize( ScrW() * 0.48, ScrH() * 0.43 )
		
		local emailsbar = emails:GetVBar()
		function emailsbar.btnUp:Paint( w, h )
		end
		function emailsbar.btnDown:Paint( w, h )
		end
		
		local color_lightGray = Color( 200, 200, 200 )
		function emailsbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, color_lightGray )
		end
		
		local color_darkGray = Color( 150, 150, 150 )
		function emailsbar:Paint( w, h )
			draw.RoundedBox( 0, 0, h * 0.023, w, h * 0.954, color_darkGray )
		end
		
		local function emailsFill( eType )
			emails:Clear()
			
			for k, v in ipairs( datapad.Emails[eType] ) do
				local email = emails:Add( "DButton" )
				email:SetText( v["title"] )
				email:Dock( TOP )
				email:DockMargin( 0, 0, 0, 5 )
				
				email.DoClick = function( self )
					net.Start( "datapad_email_get" )
						net.WriteBool( false )
						net.WriteString( v["id"] )
					net.SendToServer()
				end
			end
		end
		
		local function emailDetails( email )
			PrintTable( email )
		end
		
		local emailText = "NEW EMAIL"
		local newEmailPanels = {}
		local function newEmail()
			emailText = "SEND"
			emails:Hide()
		
			local recipientLabel = vgui.Create( "DLabel", window )
			recipientLabel:SetPos( ScrW() * 0.01, ScrH() * 0.06 )
			recipientLabel:SetSize( 100, 30 )
			recipientLabel:SetFont( "CloseCaption_Normal" )
			recipientLabel:SetText( "Recipient" )
		
			local recipient = vgui.Create( "DTextEntry", window )
			recipient:SetPos( 120, ScrH() * 0.062 )
			recipient:SetSize( ScrW() * 0.443, ScrH() * 0.02 )
			recipient:SetVerticalScrollbarEnabled( false )
			recipient:SetDrawLanguageID( false )
			recipient:SetMultiline( false )
			recipient:SetFont( "CloseCaption_Normal" )
			
			local titleLabel = vgui.Create( "DLabel", window )
			titleLabel:SetPos( ScrW() * 0.01, ScrH() * 0.1 )
			titleLabel:SetSize( 100, 30 )
			titleLabel:SetFont( "CloseCaption_Normal" )
			titleLabel:SetText( "Title" )
			
			local title = vgui.Create( "DTextEntry", window )
			title:SetPos( 120, ScrH() * 0.1 )
			title:SetSize( ScrW() * 0.443, ScrH() * 0.02 )
			title:SetVerticalScrollbarEnabled( false )
			title:SetDrawLanguageID( false )
			title:SetMultiline( false )
			title:SetFont( "CloseCaption_Normal" )
		
			local body = vgui.Create( "DTextEntry", window )
			body:SetPos( ScrW() * 0.01, ScrH() * 0.14 )
			body:SetSize( ScrW() * 0.48, ScrH() * 0.343 )
			body:SetVerticalScrollbarEnabled( true )
			body:SetDrawLanguageID( false )
			body:SetMultiline( true )
			body:SetFont( "CloseCaption_Normal" )
			
			table.insert( newEmailPanels, recipientLabel )
			table.insert( newEmailPanels, recipient )
			table.insert( newEmailPanels, titleLabel )
			table.insert( newEmailPanels, title )
			table.insert( newEmailPanels, body )
		end
		
		local function destroyNewEmail()
			emailText = "NEW EMAIL"
			emails:Show()
			
			if #newEmailPanels > 0 then
				for k, v in ipairs( newEmailPanels ) do
					v:Remove()
				end
				
				table.Empty( newEmailPanels )
			end
		end
		
		local function sendEmail()
			if #newEmailPanels == 0 or not newEmailPanels[2] or #newEmailPanels[2]:GetText() == 0 or not newEmailPanels[4] or #newEmailPanels[4]:GetText() == 0 or not newEmailPanels[5] or #newEmailPanels[5]:GetText() == 0 then return end
		
			net.Start( "datapad_email_send" )
				net.WriteString( newEmailPanels[2]:GetText() )
				net.WriteString( newEmailPanels[4]:GetText() )
				net.WriteString( newEmailPanels[5]:GetText() )
			net.SendToServer()
		end
		
		local newButt = vgui.Create( "DButton", window )
		newButt:SetText( "" )
		newButt:SetPos( ScrW() * 0.42, ScrH() * 0.032 )
		newButt:SetSize( 171, 30 )
		newButt.inb = true
		newButt.DoClick = function( self )
			if emailText == "NEW EMAIL" then
				newEmail()
			else
				sendEmail()
				destroyNewEmail()
			end
		end
		
		newButt.Paint = function( self, w, h )
			draw.RoundedBox( 25, 5, 0, w-5, h, color_gray )
			draw.SimpleText( emailText, "DermaLarge", ScrW() * 0.034, ScrH() * 0.01, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		local inboxButt = vgui.Create( "DButton", window )
		inboxButt:SetText( "" )
		inboxButt:SetPos( ScrW() * 0.01, ScrH() * 0.0285 )
		inboxButt:SetSize( 121, 40 )
		inboxButt.inb = true
		inboxButt.DoClick = function( self )
			destroyNewEmail()
			emailsFill( "in" )
			self:MoveToFront()
		end

		local sentButt = vgui.Create( "DButton", window )
		sentButt:SetText( "" )
		sentButt:SetPos( ScrW() * 0.05, ScrH() * 0.0285 )
		sentButt:SetSize( 121, 40 )
		sentButt.DoClick = function( self )
			destroyNewEmail()
			emailsFill( "out" )
			self:MoveToFront()
		end
		
		local btn_selected = Color( 0, 0, 255 )
		local btn_unselected = Color( 0, 0, 100 )
		local function cardPaint( self, w, h )
			local child = window:GetChildren()
		
			draw.RoundedBoxEx( 50, 0, 0, w, h, ( child[#child] == self and btn_selected or btn_unselected ), true, true )
			draw.SimpleText( self.inb and "Inbox" or "Sent", "DermaLarge", ScrW() * 0.023, ScrH() * 0.013, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		inboxButt.Paint = cardPaint
		sentButt.Paint = cardPaint
		inboxButt:DoClick()
		
		hook.Add( "DatapadEmailNewEmail", "DatapadEmailNew", function( eType )
			local child = window:GetChildren()
			
			if eType == "in" and child[#child] == inboxButt then
				inboxButt:DoClick()
			elseif eType == "out" and child[#child] == sentButt then
				sentButt:DoClick()
			end
		end )
		
		net.Receive( "datapad_email_details", function()
			emailDetails( net.ReadTable() )
		end )
	end
})