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
			surface.DrawRect( 1, 1, w - 2, h - 2 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetPos( ScrW() * 0.478 - 1, 1 )
		cls:SetSize( ScrW() * 0.022, ScrH() * 0.028 )
		cls.DoClick = function()
			window:Close()
		end
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and color_red or back_clr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.NoTexture()
			surface.SetDrawColor( color_white )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, 45 )
			
			return true
		end
		
		local emails = vgui.Create( "DScrollPanel", window )
		emails:SetPos( 20, ScrH() * 0.03 + 40 )
		emails:SetSize( ScrW() * 0.5 - 40, ScrH() * 0.47 - 60 )
		
		local emailsbar = emails:GetVBar()
		emailsbar.btnUp.Paint = nil
		emailsbar.btnDown.Paint = nil
		
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
				email:SetText( "" )
				email:Dock( TOP )
				
				email.DoClick = function( self )
					net.Start( "datapad_email_get" )
						net.WriteBool( false )
						net.WriteString( v["id"] )
					net.SendToServer()
				end
				
				email.Paint = function( self, w, h )
					draw.NoTexture()
				
					local clr = ( self:IsHovered() and color_gray or color_white )
					surface.SetDrawColor( clr:Unpack() )
					surface.DrawRect( 0, 0, w, h )
					
					surface.SetDrawColor( color_gray:Unpack() )
					surface.DrawLine( 0, 0, w, 0 )
					
					draw.SimpleText( v["sender_name"], "DermaDefault", 10, h * 0.5, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( v["title"], "DermaDefault", w * 0.5, h * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.SimpleText( os.date( "%H:%M:%S - %d.%m.%Y." , v["time"] ), "DermaDefault", w - 10, h * 0.5, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
			end
		end
		
		local emailText = "NEW EMAIL"
		local newShowEmailPanels = {}
		local function destroyNewShowEmail()
			emailText = "NEW EMAIL"
			emails:Show()
			
			if #newShowEmailPanels > 0 then
				for k, v in ipairs( newShowEmailPanels ) do
					v:Remove()
				end
				
				table.Empty( newShowEmailPanels )
			end
		end
		
		local function emailDetails( email )
			destroyNewShowEmail()
		
			emailText = "NEW EMAIL"
			emails:Hide()
			
			local details = vgui.Create( "DPanel", window )
			details:SetPos( 20, ScrH() * 0.03 + 40 )
			details:SetSize( ScrW() * 0.5 - 40, ScrH() * 0.47 - 60 )
			
			local color_lightGray = Color( 200, 200, 200 )
			details.Paint = function( self, w, h )
				draw.NoTexture()
				
				surface.SetDrawColor( color_white:Unpack() )
				surface.DrawRect( 0, 0, w, h )
				
				surface.SetDrawColor( color_lightGray:Unpack() )
				surface.DrawLine( 10, 50, w - 10, 50 )
			end
			
			local title = vgui.Create( "DTextEntry", window )
			title:SetPos( 30, ScrH() * 0.03 + 50 )
			title:SetSize( ScrW() * 0.5 - 60, 30 )
			title:SetFont( "ScoreboardDefaultTitle" )
			title:SetText( email["title"] )
			title:SetEnabled( false )
			title:SetDrawBackground( false )
			title:SetDrawLanguageID( false )
			
			local sender = vgui.Create( "DTextEntry", window )
			sender:SetPos( 30, ScrH() * 0.03 + 100 )
			sender:SetSize( ScrW() * 0.5 - 60, 30 )
			sender:SetFont( "HudSelectionText" )
			sender:SetText( email["sender_name"] .. " (" .. email["sender"] .. ")" )
			sender:SetEnabled( false )
			sender:SetDrawBackground( false )
			sender:SetDrawLanguageID( false )
			
			local dateTime = vgui.Create( "DTextEntry", window )
			dateTime:SetPos( ScrW() * 0.5 - 235, ScrH() * 0.03 + 100 )
			dateTime:SetSize( 205, 30 )
			dateTime:SetFont( "HudSelectionText" )
			dateTime:SetText( os.date( "%H:%M:%S - %d.%m.%Y." , email["time"] ) )
			dateTime:SetEnabled( false )
			dateTime:SetDrawBackground( false )
			dateTime:SetDrawLanguageID( false )
			
			local recipients = vgui.Create( "DTextEntry", window )
			recipients:SetPos( 30, ScrH() * 0.03 + 120 )
			recipients:SetSize( ScrW() * 0.5 - 60, 30 )
			recipients:SetFont( "DefaultSmall" )
			recipients:SetText( "Recipients: " .. email["recipients"] )
			recipients:SetEnabled( false )
			recipients:SetDrawBackground( false )
			recipients:SetDrawLanguageID( false )
			
			local content = vgui.Create( "DTextEntry", window )
			content:SetPos( 30, ScrH() * 0.03 + 175 )
			content:SetSize( ScrW() * 0.5 - 60, ScrH() * 0.47 - 205 )
			content:SetText( email["body"] )
			content:SetEnabled( false )
			content:SetVerticalScrollbarEnabled( true )
			content:SetDrawBackground( false )
			content:SetDrawLanguageID( false )
			content:SetMultiline( true )
		
			table.insert( newShowEmailPanels, details )
			table.insert( newShowEmailPanels, title )
			table.insert( newShowEmailPanels, sender )
			table.insert( newShowEmailPanels, dateTime )
			table.insert( newShowEmailPanels, recipients )
			table.insert( newShowEmailPanels, content )
			PrintTable( email )
		end
		
		local function newEmail()
			destroyNewShowEmail()
		
			emailText = "SEND"
			emails:Hide()
		
			local recipientLabel = vgui.Create( "DLabel", window )
			recipientLabel:SetPos( 20, ScrH() * 0.03 + 50 )
			recipientLabel:SetSize( 100, 30 )
			recipientLabel:SetFont( "CloseCaption_Normal" )
			recipientLabel:SetText( "Recipient" )
		
			local recipients = vgui.Create( "DTextEntry", window )
			recipients:SetPos( 120, ScrH() * 0.03 + 50 )
			recipients:SetSize( ScrW() * 0.5 - 140, 35 )
			recipients:SetVerticalScrollbarEnabled( false )
			recipients:SetDrawLanguageID( false )
			recipients:SetMultiline( false )
			recipients:SetFont( "CloseCaption_Normal" )
			
			local titleLabel = vgui.Create( "DLabel", window )
			titleLabel:SetPos( 20, ScrH() * 0.03 + 100 )
			titleLabel:SetSize( 100, 30 )
			titleLabel:SetFont( "CloseCaption_Normal" )
			titleLabel:SetText( "Title" )
			
			local title = vgui.Create( "DTextEntry", window )
			title:SetPos( 120, ScrH() * 0.03 + 100 )
			title:SetSize( ScrW() * 0.5 - 140, 35 )
			title:SetVerticalScrollbarEnabled( false )
			title:SetDrawLanguageID( false )
			title:SetMultiline( false )
			title:SetFont( "CloseCaption_Normal" )
		
			local body = vgui.Create( "DTextEntry", window )
			body:SetPos( 20, ScrH() * 0.03 + 150 )
			body:SetSize( ScrW() * 0.5 - 40, ScrH() * 0.47 - 170 )
			body:SetVerticalScrollbarEnabled( true )
			body:SetDrawLanguageID( false )
			body:SetMultiline( true )
			body:SetFont( "CloseCaption_Normal" )
			
			table.insert( newShowEmailPanels, recipientLabel )
			table.insert( newShowEmailPanels, recipients )
			table.insert( newShowEmailPanels, titleLabel )
			table.insert( newShowEmailPanels, title )
			table.insert( newShowEmailPanels, body )
		end
		
		local function sendEmail()
			if #newShowEmailPanels == 0 or not newShowEmailPanels[2] or #newShowEmailPanels[2]:GetText() == 0 or not newShowEmailPanels[4] or #newShowEmailPanels[4]:GetText() == 0 or not newShowEmailPanels[5] or #newShowEmailPanels[5]:GetText() == 0 then return end
		
			net.Start( "datapad_email_send" )
				net.WriteString( newShowEmailPanels[2]:GetText() )
				net.WriteString( newShowEmailPanels[4]:GetText() )
				net.WriteString( newShowEmailPanels[5]:GetText() )
			net.SendToServer()
		end
		
		local newButt = vgui.Create( "DButton", window )
		newButt:SetPos( ScrW() * 0.5 - 191, ScrH() * 0.03 )
		newButt:SetSize( 171, 40 )
		newButt.inb = true
		newButt.DoClick = function( self )
			if emailText == "NEW EMAIL" then
				newEmail()
			else
				sendEmail()
				destroyNewShowEmail()
			end
		end
		
		newButt.Paint = function( self, w, h )
			draw.RoundedBoxEx( 50, 0, 0, w, h, color_gray, true, true )
			draw.SimpleText( emailText, "DermaLarge", w * 0.5, h * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
			return true
		end
		
		local inboxButt = vgui.Create( "DButton", window )
		inboxButt:SetPos( 20, ScrH() * 0.03 )
		inboxButt:SetSize( 121, 40 )
		inboxButt.inb = true
		inboxButt.DoClick = function( self )
			destroyNewShowEmail()
			emailsFill( "in" )
			self:MoveToFront()
		end

		local sentButt = vgui.Create( "DButton", window )
		sentButt:SetPos( 121, ScrH() * 0.03 )
		sentButt:SetSize( 121, 40 )
		sentButt.DoClick = function( self )
			destroyNewShowEmail()
			emailsFill( "out" )
			self:MoveToFront()
		end
		
		local btn_selected = Color( 0, 0, 255 )
		local btn_unselected = Color( 0, 0, 150 )
		local function cardPaint( self, w, h )
			local child = window:GetChildren()
		
			draw.RoundedBoxEx( 50, 0, 0, w, h, ( child[#child] == self and btn_selected or btn_unselected ), true, true )
			draw.SimpleText( self.inb and "Inbox" or "Sent", "DermaLarge", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
			return true
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
		
		net.Receive( "datapad_email_details", function( len )
			local data = net.ReadData( len / 8 )
			emailDetails( util.JSONToTable( util.Decompress( data ) ) )
		end )
	end
})