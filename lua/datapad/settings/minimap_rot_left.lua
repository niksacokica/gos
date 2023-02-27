datapad:AddSetting({
	["setting"] = "mm_rot_left",
	["creator"] = "niksacokica",
	["title"] = "Minimap Rotate Left",
	["description"] = "Keybind for rotating left.",
	["category"] = "Minimap",
	["subCategory"] = "Keybinds",
	["visible"] = function( ply )
		return true
	end,
	["function"] = function()
		local bind = vgui.Create( "DButton" )
		bind:SetPos( 0, 0 )
		bind:SetSize( ScrW() * 0.05, ScrH() * 0.04 )
	
		return 0.05, 0.1, bind
	end
})