datapad:AddApp({
	["name"] = "Camera",
	["icon"] = "datapad/camera.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( color_black )
			surface.DrawRect( w * 0.002, h * 0.003, w * 0.998, h * 0.997 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetText( "" )
		cls:SetPos( ScrW() * 0.478, ScrH() * 0.001 )
		cls:SetSize( ScrW() * 0.022, ScrH() * 0.028 )
		cls.DoClick = function()
			window:Close()
		end
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( cls:IsHovered() and color_red or color_black )
			surface.DrawRect( 0, 0, w, h )
			
			surface.SetDrawColor( color_white )
			surface.DrawLine( w * 0.4, h * 0.35, w * 0.6, h * 0.65 )
			surface.DrawLine( w * 0.4, h * 0.65, w * 0.6, h * 0.35 )
			surface.DrawLine( w * 0.41, h * 0.351, w * 0.61, h * 0.651 )
			surface.DrawLine( w * 0.41, h * 0.651, w * 0.61, h * 0.351 )
		end	
	end
})