gos:AddApp({
	["name"] = "Internet",
	["icon"] = "gos/app_icons/internet.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local back_clr = Color( 40, 40, 40 )
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35)
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( 1, 1, w - 2, h - 2 )
		end
		
		local html = vgui.Create( "DHTML", window )
		html:SetPos( ScrW() * 0.0005, ScrH() * 0.028 + 30 )
		html:SetSize( ScrW() * 0.5 - 2, ScrH() * 0.472 - 30 )
		html:OpenURL( "http://wiki.garrysmod.com" )
		
		local ctrls = vgui.Create( "DHTMLControls", window )
		ctrls:SetPos( ScrW() * 0.0005, 1 )
		ctrls:SetSize( 130, ScrH() * 0.028 )
		ctrls:SetHTML( html )
		ctrls:GetChildren()[5]:Hide()
		
		local ctrlsSearch = ctrls:GetChildren()[6]
		ctrlsSearch:Dock(NODOCK)
		ctrlsSearch:SetPos( 1, ScrH() * 0.028 )
		ctrlsSearch:SetSize( ScrW() * 0.5 - 2, 30 )
		ctrlsSearch:SetParent( window )
		
		local cls = vgui.Create( "DButton", window )
		cls:SetPos( ScrW() * 0.478, 1 )
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
	end
})