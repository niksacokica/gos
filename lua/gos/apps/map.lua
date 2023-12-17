gos:AddApp({
	["name"] = "Map",
	["icon"] = "gos/app_icons/map.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local back_clr = Color( 50, 50, 50 )
		local color_gray = Color( 150, 150, 150 )
		window.Paint = function( self, w, h )		
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( 1, 1, w - 2, h - 2 )
		end
		
		local function doHullTrace( newPos )
			local tr = util.TraceHull( {
				start = newPos,
				endpos = newPos,
				mins = Vector( -20, -20, -400 ),
				maxs = Vector( 20, 20, 400 )
			} )

			return tr["Hit"]
		end
		
		local function findGoodPosition( pos )
			for x=0, 10000, 100 do
				for y=0, 10000, 100 do
					for z=1000, 10000, 100 do
						local newPos = pos + Vector( x, y, z )
						if doHullTrace( newPos ) then continue end
						
						return newPos
					end
				end
			end
			
			return nil
		end
		
		local map = vgui.Create( "DPanel", window )
		map:SetPos( 10, ScrH() * 0.028 + 1 )
		map:SetSize( ScrW() * 0.5 - 20, ScrH() * 0.472 - 11 )
		
		local camPos = findGoodPosition( LocalPlayer():GetPos() )
		local camAng = Angle(90, 0, 90)
		local color_red = Color( 255, 35, 35 )
		local localPlyMat = Material( "gos/other/mark_player.png" )
		local plyMat = Material( "gos/other/mark_player2.png" )
		local npcMat = Material( "gos/other/mark_npc.png" )
		local drawNpcs = gos:GetSetting( "mm_draw_npc", false )
		local drawPlys = gos:GetSetting( "mm_draw_ply", false )
		
		map.Paint = function( self, w, h )			
			if not camPos then
				surface.SetDrawColor( color_black )
				surface.DrawRect( 0, 0, w - ScrW() * 0.015, h - ScrH() * 0.045 )
			
				surface.SetTextColor( color_red:Unpack() )
				surface.SetTextPos( ScrW() * 0.17, ScrH() * 0.25 )
				surface.SetFont( "DermaLarge" )
				surface.DrawText( "MAP CURRENTLY UNAVAILABLE!" )
				
				return
			end
			
			local px, py = self:GetParent():GetPos()
			local x, y = self:GetPos()
			
			local old = DisableClipping( true )
			render.RenderView( {
				origin = camPos,
				angles = camAng,
				fov = 75,
				drawviewmodel = false,
				bloomtone = false,
				x = px + x, y = py + y,
				w = w, h = h
			} )
			DisableClipping( old )
			
			draw.NoTexture()
			for k, v in ipairs( ents.GetAll() ) do
				if v:IsPlayer() then
					if v == LocalPlayer() then
						surface.SetDrawColor( color_white )
						surface.SetMaterial( localPlyMat )
					else
						surface.SetDrawColor( color_white )
						surface.SetMaterial( plyMat )
						
						if not v:GetNoDraw() and not drawPlys then
							v:SetNoDraw( true )
							
							local weapon = v:GetActiveWeapon()
							if IsValid( weapon ) then
								weapon:SetNoDraw( true )
							end
						end
					end
				elseif v:IsNPC() then
					surface.SetDrawColor( color_white )
					surface.SetMaterial( npcMat )
					
					if not v:GetNoDraw() and not drawNpcs then
						v:SetNoDraw( true )
						
						local weapon = v:GetActiveWeapon()
						if IsValid( weapon ) then
							weapon:SetNoDraw( true )
						end
					end
				else
					continue
				end
				
				local pos = v:GetPos()
				local zPos = 1 / ( camPos.z - pos.z )
				
				camPos:Rotate( Angle( 0, camAng.r, 0 ) )
				pos:Rotate( Angle( 0, camAng.r, 0 ) )
				
				local finalX = w * 0.5 + ( camPos.y - pos.y ) * zPos * ( ScrW() / 3.12 )
				local finalY = h * 0.52 + ( camPos.x - pos.x ) * zPos * ( ScrH() / 1.92 )
				
				camPos:Rotate( Angle( 0, -camAng.r, 0 ) )
				
				local dims = 50000 * zPos
				local finalPos = Vector( finalX - dims * 0.5, finalY - dims * 0.5, 0 )
				
				if finalPos.x > w or finalPos.x + dims < 0 or finalPos.y > h or finalPos.y + dims < 0 then continue end
				
				surface.DrawTexturedRect( finalPos.x, finalPos.y, dims, dims )
			end
		end
		
		map.OnDelete = function( self )
			for k, v in ipairs( ents.GetAll() ) do
				if ( v:IsPlayer() or v:IsNPC() ) and v:GetNoDraw() and not ( v == LocalPlayer() ) then
					v:SetNoDraw( false )
					
					local weapon = v:GetActiveWeapon()
					if IsValid( weapon ) then
						weapon:SetNoDraw( false )
					end
				end
			end
		end
		
		local function doLineTraceUD( up )
			local tr = util.TraceLine( {
				start = camPos,
				endpos = Vector( camPos.x, camPos.y, camPos.z + ( up and 100000 or -100000 ) ),
				filter = function( ent ) return not ( ent:IsPlayer() or ent:IsNPC() ) end
			} )
			
			return tr
		end
		
		local zoomMod = gos:GetSetting( "mm_zoom_sens", 1 )
		map.OnMouseWheeled = function( self, data )
			if not camPos then return end
		
			local mod = ( ( camPos.z - doLineTraceUD( false )["HitPos"].z ) / 1000 ) * zoomMod
		
			if data > 0 and mod > 0.5 then
				camPos.z = camPos.z - 100 * mod
			elseif data < 0 and ( doLineTraceUD( true )["HitPos"].z - camPos.z ) / 1000 > 1 then
				camPos.z = camPos.z + 100 * mod
			end
		end
		
		local lastPress = nil
		local panMod = gos:GetSetting( "mm_pan_sens", 1 )
		map.OnCursorMoved = function( self, x, y )
			if input.IsMouseDown( MOUSE_LEFT ) and camPos then
				if lastPress and x > ScrW() * 0.008 and x < ScrW() * 0.5 - ScrW() * 0.015 and y > ScrH() * 0.03 and y < ScrH() * 0.5 - ScrH() * 0.045 then
					local mod = ( ( camPos.z - doLineTraceUD( false )["HitPos"].z ) / 1000 ) * panMod
					
					local tempPos = Vector( camPos )
					
					camPos:Rotate( Angle( 0, camAng.r, 0 ) )
					camPos.x = camPos.x - ( lastPress.y - y ) * mod
					camPos.y = camPos.y - ( lastPress.x - x ) * mod
					camPos:Rotate( Angle( 0, -camAng.r, 0 ) )
					
					if doHullTrace( camPos ) then camPos = tempPos end
				end
				
				lastPress = Vector(x, y, 0)
			elseif lastPress then
				lastPress = nil
			end
		end
		
		local rotMod = gos:GetSetting( "mm_rot_sens", 1 )
		local keyLeft = gos:GetSetting( "mm_rot_left", KEY_Q )
		local keyRight = gos:GetSetting( "mm_rot_right", KEY_E )
		local oldThink = window.Think
		window.Think = function( self )
			oldThink( self )
		
			if input.IsKeyDown( keyLeft ) and self:HasFocus() then
				camAng.r = camAng.r + rotMod
				
				camAng:Normalize()
			end
			if input.IsKeyDown( keyRight ) and self:HasFocus() then
				camAng.r = camAng.r - rotMod
				
				camAng:Normalize()
			end
		end
		
		hook.Add( "gOSSettingsNewValue", "MinimapSettingsChanged", function( setting, newValue )
			if setting == "mm_draw_npc" then
				drawNpcs = newValue
				
				if newValue then
					for k, v in ipairs( ents.GetAll() ) do
						if v:IsNPC() and v:GetNoDraw() then
							v:SetNoDraw( false )
							
							local weapon = v:GetActiveWeapon()
							if IsValid( weapon ) then
								weapon:SetNoDraw( false )
							end
						end
					end
				end
			elseif setting == "mm_draw_ply" then
				drawPlys = newValue
				
				if newValue then
					for k, v in ipairs( ents.GetAll() ) do
						if v:IsPlayer() and v:GetNoDraw() and not ( v == LocalPlayer() ) then
							v:SetNoDraw( false )
							
							local weapon = v:GetActiveWeapon()
							if IsValid( weapon ) then
								weapon:SetNoDraw( false )
							end
						end
					end
				end
			elseif setting == "mm_pan_sens" then
				panMod = newValue
			elseif setting == "mm_rot_sens" then
				rotMod = newValue
			elseif setting == "mm_zoom_sens" then
				zoomMod = newValue
			elseif setting == "mm_rot_left" then
				keyLeft = newValue
			elseif setting == "mm_rot_right" then
				keyRight = newValue
			end
		end	)
		
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
		
		local legend = vgui.Create( "DFrame", window )
		legend:SetPos( ScrW() * 0.5 - 210, ScrH() * 0.5 - 211 )
		legend:SetSize( 200, 200 )
		legend:SetTitle( "" )
		legend:ShowCloseButton( false )
		legend.ShowLegend = true
		
		window.OnKeyCodePressed = function( self, key )
			if tostring( key ) == "22" then
				legend.ShowLegend = not legend.ShowLegend
				
				if legend.ShowLegend then
					legend:SetSize( 200, 200 )
					legend:SetPos( ScrW() * 0.5 - 210, ScrH() * 0.5 - 211 )
				else
					legend:SetSize( 200, 50 )
					legend:SetPos( ScrW() * 0.5 - 210, ScrH() * 0.5 - 61 )
				end
			end
		end
		
		local legend_icons={
			["mark_npc"] = Material("gos/other/mark_npc.png"),
			["mark_player"] = Material("gos/other/mark_player.png"),
			["mark_player2"] = Material("gos/other/mark_player2.png")
		}		
		local function drawLegendIcon( icon, desc, x, y, w, h )
			draw.NoTexture()
	
			surface.SetMaterial( legend_icons[icon] )
			surface.DrawTexturedRect( x, y, w, h )
			
			draw.DrawText( desc, "ScoreboardDefault", w * 0.9, h * 0.31 + y, color_white, TEXT_ALIGN_LEFT )
		end
		
		local light_gray = Color( 150, 150, 150, 150 )
		legend.Paint = function( self, w, h )
			draw.NoTexture()
			surface.SetDrawColor( light_gray )
			surface.DrawRect( 0, 0, w, h )
			
			if self.ShowLegend then
				draw.DrawText( "L - Hide legend", "ScoreboardDefault", w * 0.5, h * 0.82, color_white, TEXT_ALIGN_CENTER )
				
				drawLegendIcon( "mark_npc", "- NPCs", 0, 0, w * 0.3, h * 0.3 )
				drawLegendIcon( "mark_player", "- You", 0, h * 0.25, w * 0.3, h * 0.3 )
				drawLegendIcon( "mark_player2", "- Other players", 0, h * 0.5, w * 0.3, h * 0.3 )
			else
				draw.DrawText( "L - Show legend", "ScoreboardDefault", w * 0.5, h * 0.3, color_white, TEXT_ALIGN_CENTER )
			end
		end
	end
})