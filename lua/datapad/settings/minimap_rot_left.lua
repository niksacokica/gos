datapad:AddSetting({
	["setting"] = "mm_rot_left",
	["creator"] = "niksacokica",
	["title"] = "Minimap Rotate Left",
	["description"] = "Keybind for rotating left.",
	["category"] = "Minimap",
	["subCategory"] = "Keybinds",
	["visible"] = function()
		return true
	end,
	["function"] = function()
		local bind = vgui.Create( "DButton" )
		bind:SetPos( 0, 0 )
		bind:SetSize( ScrH() * 0.04, ScrH() * 0.04 )
		bind:DockMargin( 0, 0, ScrW() * 0.012, 0 )
		bind:SetText( string.upper( input.GetKeyName( language.GetPhrase( datapad:GetSetting( "mm_rot_left", KEY_Q ) ) ) ) )
		bind:SetFont( "DermaLarge" )
		bind:SetColor( color_black )
		
		local out_clr = Color( 150, 150, 150 )
		local in_clr = Color( 70, 70, 70 )
		bind.Paint = function( self, w, h )
			surface.SetDrawColor( out_clr:Unpack() )
			surface.DrawOutlinedRect( 0, 0, w, h, 5 )
			
			surface.SetDrawColor( in_clr:Unpack() )
			surface.DrawRect( 1, 1, w - 2, h - 2 )
		end
		
		local clickPan = vgui.Create( "DPanel", bind )
		clickPan:SetPos( 0, 0 )
		clickPan:SetSize( ScrW(), ScrH() )
		clickPan:SetVisible( false )
		clickPan:MakePopup()
		
		local text_clr = Color( 255, 255, 255 )
		clickPan.Paint = function( self, w, h )
			surface.SetDrawColor( 0, 0, 0, 250 )
			surface.DrawRect( 0, 0, w, h )
			
			draw.SimpleText( "Press any button to keybind!", "DermaLarge", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		bind.DoClick = function()
			clickPan:SetVisible( true )
			clickPan:MoveToFront()
		end
		
		function clickPan:OnKeyCodePressed( key )
			datapad:SaveSetting( "mm_rot_left", key )
			bind:SetText( string.upper( input.GetKeyName( language.GetPhrase( key ) ) ) )
		
			clickPan:SetVisible( false )
		end
	
		return 0.07, 0.15, bind
	end
})