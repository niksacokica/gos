datapad:AddSetting({
	["setting"] = "dev_mode",
	["creator"] = "niksacokica",
	["title"] = "Developer mode",
	["description"] = "Enable/disable developer mode ( admin+ ).",
	["category"] = "General",
	["subCategory"] = "Developers",
	["visible"] = function()	
		return LocalPlayer():IsAdmin()
	end,
	["function"] = function()
		local toggle = vgui.Create( "DCheckBox" )
		toggle:SetPos( 0, 0 )
		toggle:SetSize( ScrW() * 0.05, ScrH() * 0.04 )
		toggle:SetValue( datapad.devMode )
		
		local togPos = toggle:GetChecked() and 0.0285 or 0.0115
		local clicked = false
		
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
		
		local color_red = Color( 255, 0, 0 )
		local color_green = Color( 0, 255, 0 )
		toggle.Paint = function( self, w, h )
			draw.RoundedBox( 50, 0, 0, ScrW() * 0.04, ScrH() * 0.04, color_black )
			draw.RoundedBox( 50, ScrW() * 0.002, ScrH() * 0.003, ScrW() * 0.036, ScrH() * 0.034, toggle:GetChecked() and color_green or color_red )
			
			draw.NoTexture()
			surface.SetDrawColor( color_white:Unpack() )
			drawCircle( ScrW() * togPos, ScrH() * 0.02, ScrH() * 0.0178, 50 )
			
			if not clicked then return end
			if toggle:GetChecked() then
				togPos = Lerp( 0.1, togPos, 0.0285 )
				
				if togPos == 0.0285 then clicked = false end
			else
				togPos = Lerp( 0.1, togPos, 0.011 )
				
				if togPos == 0.011 then clicked = false end
			end
		end
		
		function toggle:OnChange( val )
			clicked = true
			
			net.Start( "datapad_set_dev" )
				net.WriteBool( not datapad.devMode )
			net.SendToServer()
		end
		
		hook.Add( "DatapadSettingsNewValue", "DatapadDevModeChanged", function( setting, newValue )
			toggle:SetValue( newValue )
		end )
	
		return 0.05, 0.1, toggle
	end
})