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
		
		local newButt = vgui.Create( "DButton", window )
		newButt:SetText( "" )
		newButt:SetPos( ScrW() * 0.42, ScrH() * 0.032 )
		newButt:SetSize( 171, 30 )
		newButt.inb = true
		newButt.DoClick = function( self )
		end
		
		newButt.Paint = function( self, w, h )
			draw.RoundedBox( 25, 5, 0, w-5, h, color_gray )
			draw.SimpleText( "NEW EMAIL", "DermaLarge", ScrW() * 0.034, ScrH() * 0.01, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		local inboxButt = vgui.Create( "DButton", window )
		inboxButt:SetText( "" )
		inboxButt:SetPos( ScrW() * 0.01, ScrH() * 0.0285 )
		inboxButt:SetSize( 121, 40 )
		inboxButt.inb = true
		inboxButt.DoClick = function( self )
			self:MoveToFront()
		end

		local sentButt = vgui.Create( "DButton", window )
		sentButt:SetText( "" )
		sentButt:SetPos( ScrW() * 0.05, ScrH() * 0.0285 )
		sentButt:SetSize( 121, 40 )
		sentButt.DoClick = function( self )		
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
	end
})