gos:AddSetting({
	["setting"] = "mm_pan_sens",
	["creator"] = "niksacokica",
	["title"] = "Minimap Panning Sensitivity",
	["description"] = "Adjust the pan sensitivity.",
	["category"] = "Minimap",
	["subCategory"] = "Sensitivity",
	["visible"] = function()
		return true
	end,
	["function"] = function()
		local slider = vgui.Create( "DNumSlider" )
		slider:SetPos( 0, ScrH() * 0.015 )
		slider:SetWide( ScrW() * 0.2 )
		slider:SetMin( 0 )
		slider:SetMax( 2 )
		slider:SetDecimals( 2 )
		slider:SetValue( gos:GetSetting( "mm_pan_sens", 1 ) )
		
		slider.Scratch:SetEnabled( false )
		slider.Scratch:SetCursor( "arrow" )
		
		slider.Slider.Paint = function( self, w, h )
			surface.SetDrawColor( color_black:Unpack() )
			surface.DrawRect( 8, h * 0.5 - 1, w - 15, 2 )
			
			for i=0, 20 do
				if i % 10 == 0 then
					surface.DrawRect( 8 + i * ( ( w - 17 ) * 0.05 ), h * 0.5 - 10, 2, 20 )
				else
					surface.DrawRect( 8 + i * ( ( w - 17 ) * 0.05 ), h * 0.5 - 5, 2, 10 )
				end
			end
		end
		
		slider.TextArea:SetFont( "Trebuchet18" )
		
		local triangle = {
			{ x = 0, y = -5 },
			{ x = 16, y = -5 },
			{ x = 8, y = 10 }
		}
		
		slider.Slider.Knob.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 0, 0, 255 )
			draw.NoTexture()
			
			surface.DrawPoly( triangle )
		end
		
		function slider:OnValueChanged( val )
			gos:SaveSetting( "mm_pan_sens", val )
		end

		return 0.07, 0.2, slider
	end
})