datapad:AddApp({
	["name"] = "Settings",
	["icon"] = "datapad/app_icons/settings.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local back_clr = Color( 50, 50, 50 )
		local back_clr_left = Color( 70, 70, 70 )
		local back_clr_right = Color( 60, 60, 60 )
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35)
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( w * 0.0015, h * 0.002, w * 0.998, h * 0.998 )
			
			surface.SetDrawColor( back_clr_left )
			surface.DrawRect( w * 0.0015, h * 0.058, w * 0.282, h * 0.942 )
			
			surface.SetDrawColor( back_clr_right )
			surface.DrawRect( w * 0.282, h * 0.058, w * 0.718, h * 0.942 )
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
		cats:SetSize( ScrW() * 0.1, ScrH() * 0.454 )
		
		local cSbar = cats:GetVBar()
		function cSbar.btnUp:Paint( w, h )
		end
		function cSbar.btnDown:Paint( w, h )
		end
		function cSbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 10, 0, 0, w, h, color_black )
		end
		
		local color_darkGray = Color( 25, 25, 25 )
		function cSbar:Paint( w, h )
			draw.RoundedBox( 5, w * 0.4, h * 0.01, w * 0.2, h * 0.98, color_darkGray )
		end
		
		local sCats = vgui.Create( "DScrollPanel", window )
		sCats:SetPos( ScrW() * 0.15, ScrH() * 0.03 )
		sCats:SetSize( ScrW() * 0.342, ScrH() * 0.454 )
		
		local scSbar = sCats:GetVBar()
		function scSbar.btnUp:Paint( w, h )
		end
		function scSbar.btnDown:Paint( w, h )
		end
		function scSbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 10, 0, 0, w, h, color_black )
		end
		
		local color_darkGray = Color( 25, 25, 25 )
		function scSbar:Paint( w, h )
			draw.RoundedBox( 5, w * 0.4, h * 0.01, w * 0.2, h * 0.98, color_darkGray )
		end
		
		local first = true
		local selected = ""
		for cn, c in SortedPairs( datapad.settings ) do
			local cat = cats:Add( "DButton" )
			cat:SetText( "" )
			cat:Dock( TOP )
			cat:DockMargin( 0, 0, 0, 5 )
			cat:SetSize( ScrW() * 0.1, ScrH() * 0.033 )
			
			cn = string.upper( cn )
			cat.Paint = function( self, w, h )				
				draw.NoTexture()
				draw.DrawText( cn, "DermaLarge", w * 0.5, h * 0.2, color_black, TEXT_ALIGN_CENTER )
				
				if cn == selected then
					surface.SetDrawColor( color_black )
					surface.DrawLine( w * 0.04, h * 0.98, w * 0.96, h * 0.98 )
				end
			end
			
			cat.DoClick = function()
				sCats:Clear()
				selected = cn
			
				for scn, sc in SortedPairs( c ) do
					local sCat = sCats:Add( "DLabel" )
					sCat:SetText( "" )
					sCat:Dock( TOP )
					sCat:DockMargin( 0, 50, 0, 0 )
					sCat:SetHeight( ScrH() * 0.03 )
					
					scn = string.upper( scn )
					sCat.Paint = function( self, w, h )				
						draw.NoTexture()
						draw.DrawText( scn, "DermaLarge", 0, h * 0.09, color_white )
						
						surface.SetDrawColor( color_white )
						surface.DrawLine( 0, h * 0.98, w * 0.96, h * 0.98 )
					end
					
					for sn, s in SortedPairs( sc ) do
						local sHeight, sWidth, sPan = s["function"]()
					
						local sBack = sCats:Add( "DPanel" )
						sBack:Dock( TOP )
						sBack:DockMargin( 0, 10, 0, 0 )
						sBack:SetHeight( ScrH() * sHeight )
						sBack.Paint = function( self, w, h )
						end
						
						local sLeft = vgui.Create( "DPanel", sBack )
						sLeft:Dock( LEFT )
						sLeft:SetWidth( ScrW() * sWidth )
						sLeft.Paint = function( self, w, h )
						end
						
						local sRight = vgui.Create( "DPanel", sBack )
						sRight:Dock( RIGHT )
						sRight:DockMargin( sPan:GetDockMargin() )
						sRight.Paint = function( self, w, h )
						end
						
						if sPan then
							sPan:SetParent( sRight )
							sRight:SetWidth( ScrW() * 0.001 + sPan:GetWide() )
						end
						
						local sTitle = vgui.Create( "DLabel", sLeft )
						sTitle:SetText( s["title"] )
						sTitle:SetFont( "Trebuchet24" )
						sTitle:SetHeight( ScrH() * 0.03 )
						sTitle:SetWrap( true )
						sTitle:Dock( TOP )
						
						local sDesc = vgui.Create( "DLabel", sLeft )
						sDesc:SetText( s["description"] )
						sDesc:SetWrap( true )
						sDesc:SetHeight( sLeft:GetTall() )
						sDesc:Dock( TOP )
						sDesc:DockMargin( 5, 0, 0, 0 )
						
						if not s["visible"]() then sPan:Remove() end
					end
				end
			end
			
			if first then
				cat:DoClick()
			
				first = false
			end
		end
	end
})

function datapad:AddSetting( setting )
	self.settings = istable( self.settings ) and self.settings or {}
	
	local sn = string.lower( setting["setting"] )
	setting["category"] = #setting["category"] > 0 and setting["category"] or "General"
	setting["subCategory"] = #setting["subCategory"] > 0 and setting["subCategory"] or "General"
	
	if #sn == 0 then return end
	
	if istable( self.settings[setting["category"]] ) and istable( self.settings[setting["category"]][setting["subCategory"]] ) and istable( self.settings[setting["category"]][setting["subCategory"]][sn] ) and not datapad.devMode then
		ErrorNoHalt( "Setting with the name '" .. sn .. "' already exists for the path '" .. setting["category"] .. "/" .. setting["subCategory"] .. "'!" )
	else
		self.settings[setting["category"]] = istable( self.settings[setting["category"]] ) and self.settings[setting["category"]] or {}
		self.settings[setting["category"]][setting["subCategory"]] = istable( self.settings[setting["category"]][setting["subCategory"]] ) and self.settings[setting["category"]][setting["subCategory"]] or {}
		self.settings[setting["category"]][setting["subCategory"]][sn] = setting
	end
end

function datapad:GetSetting( setting, defaultReturn )
	self.settingsValues = istable( self.settingsValues ) and self.settingsValues or {}

	if not file.Exists( "datapad/personal_files/appdata/settings.json", "DATA" ) then
		self.settingsValues = {}
		file.Write( "datapad/personal_files/appdata/settings.json", util.TableToJSON( self.settingsValues, true ) )
		
		return defaultReturn
	elseif table.IsEmpty( self.settingsValues ) then
		self.settingsValues = util.JSONToTable( file.Read( "datapad/personal_files/appdata/settings.json", "DATA" ) )
	end
	
	return ( self.settingsValues[setting] == nil and defaultReturn or self.settingsValues[setting] )
end

function datapad:SaveSetting( setting, newValue )
	self.settingsValues = istable( self.settingsValues ) and self.settingsValues or {}
	self.settingsValues[setting] = newValue
	
	file.Write( "datapad/personal_files/appdata/settings.json", util.TableToJSON( self.settingsValues, true ) )
	
	hook.Run( "DatapadSettingsNewValue", setting, newValue )
end