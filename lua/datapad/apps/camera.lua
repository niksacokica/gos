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
			surface.DrawRect( 1, 1, w -2, h - 2 )
			
			local x, y = self:GetPos()
			
			local old = DisableClipping( true )
			render.RenderView( {
				origin = LocalPlayer():EyePos(),
				angles = LocalPlayer():EyeAngles(),
				fov = 75,
				drawviewmodel = false,
				x = x + ScrH() * 0.015, y = y + ScrH() * 0.029 + 1,
				w = w - ScrH() * 0.03, h = h - ScrH() * 0.045
			} )
			DisableClipping( old )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetPos( ScrW() * 0.478, 1 )
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
			
			return true
		end
		
		local photo = vgui.Create( "DButton", window )
		photo:SetPos( ScrW() * 0.424, ScrH() * 0.2 )
		photo:SetSize( ScrH() * 0.1, ScrH() * 0.1 )
		photo.DoClick = function()
			LocalPlayer():DrawViewModel( false )
			window:GetParent():Hide()
			
			LocalPlayer():ConCommand( "jpeg" )
			
			hook.Add( "HUDShouldDraw", "CamNoHUD", function()
				return false
			end )
			
			timer.Simple( 1, function()
				hook.Remove( "HUDShouldDraw", "CamNoHUD" )
			
				window:GetParent():Show()
				LocalPlayer():DrawViewModel( true )
			end )
			
			return true
		end
		
		local plyAngles = LocalPlayer():LocalEyeAngles()
		hook.Add( "CreateMove", "CamFreeze", function( cmd )
			if pic then
				cmd:SetViewAngles( plyAngles )
				cmd:ClearButtons()
				cmd:ClearMovement()
			end
		end )
		
		local function drawCircle( x, y, radius, seg )
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
		
			surface.SetDrawColor( 255, 255, 255, 200 )
			drawCircle( w * 0.5, h * 0.5, h * 0.5, 25 )
			
			return true
		end
	end
})