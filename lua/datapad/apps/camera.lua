datapad:AddApp({
	["name"] = "Camera",
	["icon"] = "datapad/app_icons/camera.png",
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
			
			local x, y = self:GetPos()
			
			local old = DisableClipping( true )
			render.RenderView( {
				origin = LocalPlayer():EyePos(),
				angles = LocalPlayer():EyeAngles(),
				fov = 75,
				drawviewmodel = false,
				x = x + ScrH() * 0.015, y = y + ScrH() * 0.029,
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
			
			draw.NoTexture()
			surface.SetDrawColor( color_white )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, 45 )
		end
		
		local pic = false
		local photo = vgui.Create( "DButton", window )
		photo:SetText( "" )
		photo:SetPos( ScrW() * 0.424, ScrH() * 0.2 )
		photo:SetSize( ScrH() * 0.1, ScrH() * 0.1 )
		photo.DoClick = function()
			LocalPlayer():DrawViewModel( false )
			window:GetParent():Hide()
			
			pic = true
			
			LocalPlayer():ConCommand( "jpeg" )
			
			timer.Simple( 1, function()
				pic = false
				window:GetParent():Show()
				LocalPlayer():DrawViewModel( true )
			end )
		end
		
		hook.Add( "HUDShouldDraw", "CamNoHUD", function()
			if pic then
				return false
			end
		end )
		
		local plyAngles = LocalPlayer():LocalEyeAngles()
		hook.Add( "CreateMove", "CamFreeze", function( cmd )
			if pic then
				cmd:SetViewAngles( plyAngles )
				cmd:ClearButtons()
				cmd:ClearMovement()
			end
		end )
		
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
	end
})