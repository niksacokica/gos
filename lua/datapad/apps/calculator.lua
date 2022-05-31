datapad.addApp({
	["name"] = "Calculator",
	["icon"] = "datapad/calculator.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.3, ScrH() * 0.3 )
		window:SetSize( ScrW() * 0.17, ScrH() * 0.47 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local background_color = Color( 222, 222, 222, 232 )
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( background_color )
			surface.DrawRect( w * 0.004, h * 0.003, w * 0.996, h * 0.997 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetText( "" )
		cls:SetPos( ScrW() * 0.1444, ScrH() * 0.001 )
		cls:SetSize( ScrW() * 0.025, ScrH() * 0.03 )
		cls.DoClick = function()
			window:Close()
		end
		
		local xClr = Color( 255, 255, 255, 0 )
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( cls:IsHovered() and color_red or xClr )
			surface.DrawRect( 0, 0, w, h )
			
			surface.SetDrawColor( color_black )
			surface.DrawLine( w * 0.4, h * 0.35, w * 0.6, h * 0.65 )
			surface.DrawLine( w * 0.4, h * 0.65, w * 0.6, h * 0.35 )
			surface.DrawLine( w * 0.41, h * 0.351, w * 0.61, h * 0.651 )
			surface.DrawLine( w * 0.41, h * 0.651, w * 0.61, h * 0.351 )
		end	
		local clrGrey = Color( 242, 242, 242 )
		local buttons = {
			[1] = {
				["name"] = "%",
				["clr"] = clrGrey
			},
			[2] = {
				["name"] = "CE",
				["clr"] = clrGrey
			},
			[3] = {
				["name"] = "C",
				["clr"] = clrGrey
			},
			[4] = {
				["name"] = "?",
				["clr"] = clrGrey
			},
			
			[5] = {
				["name"] = "1/X",
				["clr"] = clrGrey
			},
			[6] = {
				["name"] = "X^2",
				["clr"] = clrGrey
			},
			[7] = {
				["name"] = "?",
				["clr"] = clrGrey
			},
			[8] = {
				["name"] = "?",
				["clr"] = clrGrey
			},
			
			[9] = {
				["name"] = "7",
				["clr"] = color_white
			},
			[10] = {
				["name"] = "8",
				["clr"] = color_white
			},
			[11] = {
				["name"] = "9",
				["clr"] = color_white
			},
			[12] = {
				["name"] = "X",
				["clr"] = clrGrey
			},
			
			[13] = {
				["name"] = "4",
				["clr"] = color_white
			},
			[14] = {
				["name"] = "5",
				["clr"] = color_white
			},
			[15] = {
				["name"] = "6",
				["clr"] = color_white
			},
			[16] = {
				["name"] = "-",
				["clr"] = clrGrey
			},
			
			[17] = {
				["name"] = "1",
				["clr"] = color_white
			},
			[18] = {
				["name"] = "2",
				["clr"] = color_white
			},
			[19] = {
				["name"] = "3",
				["clr"] = color_white
			},
			[20] = {
				["name"] = "+",
				["clr"] = clrGrey
			},
			
			[21] = {
				["name"] = "+/-",
				["clr"] = color_white
			},
			[22] = {
				["name"] = "0",
				["clr"] = color_white
			},
			[23] = {
				["name"] = ",",
				["clr"] = color_white
			},
			[24] = {
				["name"] = "=",
				["clr"] = clrGrey
			}
		}
		
		local w = 0.002
		local h = 0.122
		--[[for k, v in ipairs( buttons ) do			
			local but = vgui.Create( "DButton", window )
			but:SetText( v["name"] )
			but:SetPos( ScrW() * w, ScrH() * h )
			but:SetSize( ScrW() * 0.041, ScrH() * 0.056 )
			
			local hvr = v["clr"]
			hvr.a = 100
			but.Paint = function( self, w, h )
				surface.SetDrawColor( but:IsHovered() and hvr or v["clr"] )
				surface.DrawRect( 0, 0, w, h )
			end	
			
			w = w + 0.042
			if w > 0.168 then
				w = 0.002
				h = h + 0.058
			end
		end]]
	end
})