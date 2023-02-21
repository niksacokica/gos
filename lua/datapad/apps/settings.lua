datapad:AddApp({
	["name"] = "Email",
	["icon"] = "datapad/app_icons/settings.png",
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
			surface.DrawRect( w * 0.001, h * 0.002, w * 0.999, h * 0.998 )
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
		
		local cats = vgui.Create( "DScrollPanel", window )
		cats:SetPos( ScrW() * 0.01, ScrH() * 0.03 )
		cats:SetSize( ScrW() * 0.1, ScrH() * 0.1 )
		for k, v in SortedPairsByMemberValue( datapad.options, "category" ) do
			local cat = cats:Add( "DButton" )
			cat:SetText( k )
			cat:Dock( TOP )
			cat:DockMargin( 0, 0, 0, 5 )
		end
	end
})

function datapad:AddOption( option )
	self.options = istable( self.options ) and self.options or {}
	self.oCategories = istable( self.oCategories ) and self.oCategories or {}
	
	local on = string.lower( option["option"] )
	local oc = string.lower( option["category"] )
	--if istable( self.options[on] ) then
		--ErrorNoHalt( "Option with the name '" .. on .. "' already exists!" )
	--else
		self.options[on] = option
	--end
	
	self.oCategories[oc] = true
end