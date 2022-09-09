datapad:AddApp({
	["name"] = "Camera",
	["icon"] = "datapad/camera.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local back_clr = Color( 50, 50, 50 )
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( w * 0.002, h * 0.003, w * 0.998, h * 0.997 )
			
			local x, y = self:GetPos()
			
			local old = DisableClipping( true )
			render.RenderView( {
				origin = LocalPlayer():GetActiveWeapon():GetPos(),
				angles = LocalPlayer():EyeAngles(),
				fov = 75,
				drawviewmodel = false,
				x = x + ScrH() * 0.015, y = y + ScrH() * 0.03,
				w = w - ScrH() * 0.03, h = h - ScrH() * 0.045
			} )
			DisableClipping( old )
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
			
			surface.SetDrawColor( color_white )
			surface.DrawLine( w * 0.4, h * 0.35, w * 0.6, h * 0.65 )
			surface.DrawLine( w * 0.4, h * 0.65, w * 0.6, h * 0.35 )
			surface.DrawLine( w * 0.41, h * 0.351, w * 0.61, h * 0.651 )
			surface.DrawLine( w * 0.41, h * 0.651, w * 0.61, h * 0.351 )
		end	
		
		local noHUD = false
		local photo = vgui.Create( "DButton", window )
		photo:SetText( "" )
		photo:SetPos( ScrW() * 0.424, ScrH() * 0.2 )
		photo:SetSize( ScrH() * 0.1, ScrH() * 0.1 )
		photo.DoClick = function()
			LocalPlayer():DrawViewModel( false )
			window:GetParent():Hide()
			noHUD = true
			
			LocalPlayer():ConCommand( "jpeg" )
			
			timer.Simple( 1, function()
				noHUD = false
				window:GetParent():Show()
				LocalPlayer():DrawViewModel( true )
			end )
		end
		
		hook.Add( "HUDShouldDraw", "CamNoHUD", function()
			if noHUD then
				return false
			end
		end )
		
		function surface.DrawCircleFilled( x, y, radius, seg )
			local cir = {}

			table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
			for i = 0, seg do
				local a = math.rad( ( i / seg ) * -360 )
				table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
			end

			local a = math.rad( 0 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

			surface.DrawPoly( cir )
		end
		
		photo.Paint = function( self, w, h )
			draw.NoTexture()
		
			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.DrawCircleFilled( w * 0.5, h * 0.5, h * 0.5, 25 )
			
			surface.SetDrawColor( 0, 0, 0, 255)
			surface.DrawRect( w * 0.15, w * 0.3, w * 0.02, w * 0.4 )
			surface.DrawRect( w * 0.84, w * 0.3, w * 0.02, w * 0.4 )
			surface.DrawRect( w * 0.15, w * 0.7, w * 0.71, w * 0.02 )
			
			surface.DrawRect( w * 0.15, w * 0.3, w * 0.2, w * 0.02 )
			surface.DrawRect( w * 0.65, w * 0.3, w * 0.2, w * 0.02 )
			
			surface.DrawRect( w * 0.33, w * 0.22, w * 0.02, w * 0.1 )
			surface.DrawRect( w * 0.65, w * 0.22, w * 0.02, w * 0.1 )
			surface.DrawRect( w * 0.33, w * 0.22, w * 0.35, w * 0.02 )
			
			surface.DrawCircleFilled( w * 0.5, h * 0.5, h * 0.15, 50 )
			
			surface.DrawCircleFilled( w * 0.75, h * 0.4, h * 0.03, 25 )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawCircleFilled( w * 0.5, h * 0.5, h * 0.125, 50 )
		end
		
		local settings = vgui.Create( "DButton", window )
		settings:SetText( "" )
		settings:SetPos( ScrW() * 0.005, ScrH() * 0.008 )
		settings:SetSize( ScrH() * 0.1, ScrH() * 0.1 )
		settings.DoClick = function()
			
		end
		
		local cog = Material( "icon16/cog.png" )
		settings.Paint = function( self, w, h )
			draw.NoTexture()
		
			surface.SetMaterial( cog )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 0, 0, w * 0.16, h * 0.16 )
		end
	end
})