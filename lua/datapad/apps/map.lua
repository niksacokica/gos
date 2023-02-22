datapad:AddApp({
	["name"] = "Map",
	["icon"] = "datapad/app_icons/map.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
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
		
		local camPos = findGoodPosition( LocalPlayer():GetPos() )
		local camAng = Angle(90, 0, 90)
		
		local back_clr = Color( 50, 50, 50 )
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35 )
		local localPlyMat = Material( "datapad/other/mark_player.png" )
		local plyMat = Material( "datapad/other/mark_player2.png" )
		local npcMat = Material( "datapad/other/mark_npc.png" )
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( w * 0.001, h * 0.002, w * 0.999, h * 0.998 )
			
			if not camPos then
				surface.SetDrawColor( color_black )
				surface.DrawRect( ScrW() * 0.008, ScrH() * 0.03, w - ScrW() * 0.015, h - ScrH() * 0.045 )
			
				surface.SetTextColor( color_red:Unpack() )
				surface.SetTextPos( ScrW() * 0.17, ScrH() * 0.25 )
				surface.SetFont( "DermaLarge" )
				surface.DrawText( "MAP CURRENTLY UNAVAILABLE!" )
				return
			end
			
			local x, y = self:GetPos()
			local width = w - ScrH() * 0.03
			local height = h - ScrH() * 0.045
			
			local old = DisableClipping( true )
			render.RenderView( {
				origin = camPos,
				angles = camAng,
				fov = 75,
				drawviewmodel = false,
				bloomtone = false,
				x = x + ScrW() * 0.008, y = y + ScrH() * 0.03,
				w = w - ScrW() * 0.015, h = h - ScrH() * 0.045
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
						
						if not v:GetNoDraw() then
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
					
					if not v:GetNoDraw() then
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
				
				if finalPos.x + dims > w - ScrH() * 0.01 or finalPos.x + dims * 0.5 < ScrH() * 0.025 or finalPos.y + dims > h - ScrH() * 0.01 or finalPos.y + dims * 0.5 < ScrH() * 0.045 then continue end
				
				surface.DrawTexturedRect( finalPos.x, finalPos.y, dims, dims )
			end
		end
		
		window.OnDelete = function( self )
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
		
		window.OnMouseWheeled = function( self, data )
			if not camPos then return end
		
			local mod = ( camPos.z - doLineTraceUD( false )["HitPos"].z ) / 1000
		
			if data > 0 and mod > 0.5 then
				camPos.z = camPos.z - 100 * mod
			elseif data < 0 and ( doLineTraceUD( true )["HitPos"].z - camPos.z ) / 1000 > 1 then
				camPos.z = camPos.z + 100 * mod
			end
		end
		
		local lastPress = nil
		window.OnCursorMoved = function( self, x, y )
			if input.IsMouseDown( MOUSE_LEFT ) and camPos then
				if lastPress then
					local mod = ( camPos.z - doLineTraceUD( false )["HitPos"].z ) / 1000
					
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
		
		window.Think = function( self )
			if input.IsKeyDown( KEY_Q ) then
				camAng.r = camAng.r + 0.5
				
				camAng:Normalize()
			elseif input.IsKeyDown( KEY_E ) then
				camAng.r = camAng.r - 0.5
				
				camAng:Normalize()
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