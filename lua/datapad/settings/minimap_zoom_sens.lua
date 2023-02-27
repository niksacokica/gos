datapad:AddSetting({
	["setting"] = "mm_zoom_sens",
	["creator"] = "niksacokica",
	["title"] = "Minimap Zoom Sensitivity",
	["description"] = "Adjust the zoom sensitivity.",
	["category"] = "Minimap",
	["subCategory"] = "Sensitivity",
	["visible"] = function( ply )
		return true
	end,
	["function"] = function()
		local slider = vgui.Create( "DNumSlider" )
		slider:SetPos( 0, ScrH() * 0.015 )
		slider:SetWide( ScrW() * 0.2 )
		slider:SetMin( 0 )
		slider:SetMax( 2 )
		slider:SetDecimals( 2 )
		slider:SetValue( datapad:GetSetting( "mm_zoom_sens", 1 ) )
		
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
			datapad:SaveSetting( "mm_zoom_sens", val )
		end

		return 0.05, 0.13, slider
	end
})