datapad:AddApp({
	["name"] = "Map",
	["icon"] = "datapad/map.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local back_clr = Color( 50, 50, 50 )
		local camPos = LocalPlayer():GetPos() + Vector(0, 0, 1000)
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( w * 0.001, h * 0.002, w * 0.999, h * 0.998 )
			
			local x, y = self:GetPos()
			local width = w - ScrH() * 0.03
			local height = h - ScrH() * 0.045
			
			local old = DisableClipping( true )
			render.RenderView( {
				origin = camPos,
				angles = Angle(90, 0, 0),
				fov = 75,
				drawviewmodel = false,
				bloomtone = false,
				x = x + ScrH() * 0.015, y = y + ScrH() * 0.03,
				w = w - ScrH() * 0.03, h = h - ScrH() * 0.045
			} )
			DisableClipping( old )
			
			draw.NoTexture()
			for k, v in ipairs( ents.GetAll() ) do
				if v:IsPlayer() then
					if v == LocalPlayer() then
						surface.SetDrawColor( 0, 0, 255, 255 )
					else
						surface.SetDrawColor( 0, 255, 0, 255 )
					end
				elseif v:IsNPC() then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					continue
				end
				
				local pos = v:GetPos()
				local zPos = 1 / ( camPos.z - pos.z )
				local xPos = camPos.x - pos.x
				local yPos = camPos.y - pos.y
				
				local finalX = w * 0.5 + yPos * zPos * ( ScrW() / 3.12)
				local finalY = h * 0.52 + xPos * zPos * ( ScrH() / 1.92)
				if finalX > w - ScrH() * 0.03 or finalX < ScrH() * 0.03 or finalY > h - ScrH() * 0.03 or finalY < ScrH() * 0.044 then continue end
				
				surface.DrawCircleFilled( finalX, finalY, 20000 * zPos, 25 )
			end
		end
		
		window.OnMouseWheeled = function( self, data )
			if data > 0 then
				camPos.z = camPos.z - 100
			elseif data < 0 then
				camPos.z = camPos.z + 100
			end
		end
		
		local lastPress = nil
		window.OnCursorMoved = function( self, x, y )
			if input.IsMouseDown( MOUSE_LEFT ) then
				if lastPress then				
					camPos.x = camPos.x - ( lastPress.y - y ) * ( camPos.z - LocalPlayer():GetPos().z ) / 1000
					camPos.y = camPos.y - ( lastPress.x - x ) * ( camPos.z - LocalPlayer():GetPos().z ) / 1000
				end
				
				lastPress = Vector(x, y, 0)
			elseif lastPress then
				lastPress = nil
			end
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
	end
})