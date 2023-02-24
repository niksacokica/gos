datapad:AddSetting({
	["setting"] = "mm_pan_sens",
	["creator"] = "niksacokica",
	["title"] = "Minimap Panning Sensitivity",
	["description"] = "Adjust the pan sensitivity.",
	["category"] = "minimap",
	["subCategory"] = "sensitivity",
	["function"] = function()
		local slider = vgui.Create( "DNumSlider" )
		slider:SetPos( 0, 0 )
		slider:SetWide( ScrW() * 0.15 )
		slider:SetMin( 0 )
		slider:SetMax( 2 )
		slider:SetDecimals( 2 )
		slider:SetValue( datapad:GetSetting( "mm_pan_sens", 1 ) )
		
		slider.Scratch:SetEnabled( false )
		slider.Scratch:SetCursor( "arrow" )
		
		PrintTable( slider:GetTable() )
		
		slider.Slider.Paint = function( self, w, h )
			surface.SetDrawColor( color_black )
			surface.DrawRect( 8, h * 0.5, w - 16, 2 )
			
			for i=0, 3 do
				surface.DrawRect( 8 + i * ( w / 3 ), h * 0.5 - 4, 2, 10 )
			end
		end

		return 0.05, 0.14, slider
	end
})