surface.CreateFont( "NumberFont", {
	font = "Roboto",
	size = 64
})

datapad:AddApp({
	["name"] = "Calculator",
	["icon"] = "datapad/app_icons/calculator.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.3, ScrH() * 0.3 )
		window:SetSize( ScrW() * 0.17, ScrH() * 0.47 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local background_color = Color( 222, 222, 222, 232 )
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35)
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( background_color )
			surface.DrawRect( w * 0.004, h * 0.002, w * 0.997, h * 0.998 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetText( "" )
		cls:SetPos( ScrW() * 0.1446, ScrH() * 0.001 )
		cls:SetSize( ScrW() * 0.025, ScrH() * 0.03 )
		cls.DoClick = function()
			window:Close()
		end
		
		local xClr = Color( 255, 255, 255, 0 )
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( cls:IsHovered() and color_red or xClr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.NoTexture()
			surface.SetDrawColor( color_black )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.04, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.04, h * 0.5, 45 )
		end
		
		local nums = vgui.Create( "DLabel", window )
		nums:SetPos( ScrW() * 0.003, ScrH() * 0.06 )
		nums:SetText( "0" )
		nums:SetFont( "NumberFont" )
		nums:SetTextColor( color_black )
		nums:SetSize( ScrW() * 0.165, ScrH() * 0.04 )
		nums:SetContentAlignment( 6 )
		
		local calc = {
			decimals = 0,
			decimal = false,
			result = false,
			value = 0,
			res = 0,
			tmp = nil,
			action = "",
			
			["+"] = function( value, res )
				return value + res
			end,
			
			["-"] = function( value, res )
				return res - value
			end,
			
			["X"] = function( value, res )
				return value * res
			end,
			
			["/"] = function( value, res )
				return res / value
			end,
			
			UpdateDisplay = function( self )
				if self.value >= 10 ^ 99 or self.value <= -10 ^ 99 then
					nums:SetText( string.Comma( string.format( "%.3e", self.value ) ) )
				elseif self.value >= 10 ^ 9 or self.value <= -10 ^ 9 then
					nums:SetText( string.Comma( string.format( "%.4e", self.value ) ) )
				else
					nums:SetText( string.Comma( self.decimals > 0 and string.format( "%.9g", self.value ) or self.value ) .. ( ( self.decimal and self.decimals == 0 ) and "." or "" ) )
				end
			end,
			
			AddNum = function( self, num )
				if self.result or not self.value then
					self.value = num
					
					self.decimals = 0
					self.decimal = false
					self.result = false
				else	
					if self.decimal then
						self.decimals = self.decimals + 1
					end
					
					self.value = self.value * ( self.decimal and 1 or 10 ) + ( self.value >= 0 and num or -num ) * 10 ^ -self.decimals
				end
				
				self.tmp = self.value
				self:UpdateDisplay( self )
			end,
			
			AddDecimal = function( self )
				if self.result or not self.value then
					self.value = 0
					
					self.result = false
				end
				self.decimal = true
				
				self:UpdateDisplay()
			end,
			
			ChangeSign = function( self )
				self.value = self.value * -1
				
				self:UpdateDisplay()
			end,
			
			CE = function( self )
				self.value = 0
				self.tmp = nil
				self.decimals = 0
				self.decimal = false
				self.result = false
					
				self:UpdateDisplay()
			end,
			
			C = function( self )
				self:CE()
				self.action = ""
				self.res = 0
					
				self:UpdateDisplay()
			end,
			
			DEL = function( self )
				if not self.value then return end
			
				self.value = self.value > 0 and math.floor( self.value / 10 ) or math.ceil( self.value / 10 )
				self.tmp = self.value
					
				self:UpdateDisplay()
			end,
			
			Pow = function( self )
				if not self.value then return end
			
				self.value = self.value * self.value
				self.tmp = self.value
				self.result = true
					
				self:UpdateDisplay()
			end,
			
			Sqrt = function( self )
				if not self.value then return end
			
				self.value = math.sqrt( self.value )
				self.tmp = self.value
				self.result = true
					
				self:UpdateDisplay()
			end,
			
			Inv = function( self )
				if not self.value then return end
			
				self.value = 1 / self.value
				self.tmp = self.value
				self.result = true
					
				self:UpdateDisplay()
			end,
			
			BasicMath = function( self, val )
				self.tmp = self.value and self.value or self.tmp
			
				if self.action ~= "" and self.value then
					self.value = self[self.action]( self.value, self.res )
				end
				
				self.action = val
				if not self.value then return end
				
				self:UpdateDisplay()
				self.res = self.value
				self.value = nil
			end,
			
			Eq = function( self )
				self.result = true
			
				self.value = self.tmp
				if self.action ~= "" and self.tmp then
					self.value = self[self.action]( self.value, self.res )
				end
				
				if not self.value then return end
				
				self:UpdateDisplay()
				self.res = self.value
				self.value = nil
			end,
			
			Percentage = function( self )			
				if not self.value then return end
				
				local tmp = self.value
				self.value = self.res / 100 * self.value
				
				self:UpdateDisplay()
				self.res = self.value
				self.value = tmp
			end
		}
		
		local clrGrey = Color( 242, 242, 242 )
		local buttons = {
			["%"] = {
				["pos"] = 1,
				["clr"] = clrGrey,
				["func"] = function()
					calc:Percentage()
				end
			},
			["CE"] = {
				["pos"] = 2,
				["clr"] = clrGrey,
				["func"] = function()
					calc:CE()
				end
			},
			["C"] = {
				["pos"] = 3,
				["clr"] = clrGrey,
				["func"] = function()
					calc:C()
				end
			},
			["DEL"] = {
				["pos"] = 4,
				["clr"] = clrGrey,
				["func"] = function()
					calc:DEL()
				end
			},
			
			["1/X"] = {
				["pos"] = 5,
				["clr"] = clrGrey,
				["func"] = function()
					calc:Inv()
				end
			},
			["x²"] = {
				["pos"] = 6,
				["clr"] = clrGrey,
				["func"] = function()
					calc:Pow()
				end
			},
			["2√X"] = {
				["pos"] = 7,
				["clr"] = clrGrey,
				["func"] = function()
					calc:Sqrt()
				end
			},
			["/"] = {
				["pos"] = 8,
				["clr"] = clrGrey,
				["func"] = function()
					calc:BasicMath( "/" )
				end
			},
			
			["7"] = {
				["pos"] = 9,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 7 )
				end
			},
			["8"] = {
				["pos"] = 10,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 8 )
				end
			},
			["9"] = {
				["pos"] = 11,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 9 )
				end
			},
			["X"] = {
				["pos"] = 12,
				["clr"] = clrGrey,
				["func"] = function()
					calc:BasicMath( "X" )
				end
			},
			
			["4"] = {
				["pos"] = 13,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 4 )
				end
			},
			["5"] = {
				["pos"] = 14,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 5 )
				end
			},
			["6"] = {
				["pos"] = 15,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 6 )
				end
			},
			["-"] = {
				["pos"] = 16,
				["clr"] = clrGrey,
				["func"] = function()
					calc:BasicMath( "-" )
				end
			},
			
			["1"] = {
				["pos"] = 17,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 1 )
				end
			},
			["2"] = {
				["pos"] = 18,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 2 )
				end
			},
			["3"] = {
				["pos"] = 19,
				["clr"] = color_white,
				["func"] = function()
					calc:AddNum( 3 )
				end
			},
			["+"] = {
				["pos"] = 20,
				["clr"] = clrGrey,
				["func"] = function()
					calc:BasicMath( "+" )
				end
			},
			
			["+/-"] = {
				["pos"] = 21,
				["clr"] = color_white,
				["func"] = function()
					calc:ChangeSign()
				end
			},
			["0"] = {
				["pos"] = 22,
				["clr"] = color_white,
				["func"] = function()	
					calc:AddNum( 0 )
				end
			},
			["."] = {
				["pos"] = 23,
				["clr"] = color_white,
				["func"] = function()
					calc:AddDecimal()
				end
			},
			["="] = {
				["pos"] = 24,
				["clr"] = Color( 153, 204, 234 ),
				["func"] = function()
					calc:Eq()
				end
			}
		}
		
		local grid = vgui.Create( "DGrid", window )
		grid:SetPos( ScrW() * 0.0025, ScrH() * 0.124 )
		grid:SetCols( 4 )
		grid:SetColWide( ScrW() * 0.0417 )
		grid:SetRowHeight( ScrW() * 0.0323 )
		
		for k, v in SortedPairsByMemberValue( buttons, "pos" ) do
			local but = vgui.Create( "DButton" )
			but:SetFont( "DermaLarge" )
			but:SetText( k )
			but:SetSize( ScrW() * 0.041, ScrH() * 0.056 )
			
			grid:AddItem( but )
			
			local hvrg = Color( 200, 200, 200 )
			local hvrb = Color( 95, 185, 238 )
			local pvrg = Color( 175, 175, 175 )
			local pvrb = Color( 38, 166, 242 )
			but.UpdateColours = function( self, skin ) end
			but.Paint = function( self, w, h )
				surface.SetDrawColor( ( but:IsDown() and ( k == "=" and pvrb or pvrg ) or ( but:IsHovered() and ( k== "=" and hvrb or hvrg ) or v["clr"] ) ):Unpack() )
				surface.DrawRect( 0, 0, w, h )
			end
			but.DoClick = v["func"]
		end
		
		local keyCodes = {
			["1"] = "0",
			["2"] = "1",
			["3"] = "2",
			["4"] = "3",
			["5"] = "4",
			["6"] = "5",
			["7"] = "6",
			["8"] = "7",
			["9"] = "8",
			["10"] = "9",
			["37"] = "0",
			["38"] = "1",
			["39"] = "2",
			["40"] = "3",
			["41"] = "4",
			["42"] = "5",
			["43"] = "6",
			["44"] = "7",
			["45"] = "8",
			["46"] = "9",
			["47"] = "/",
			["48"] = "X",
			["49"] = "-",
			["50"] = "+",
			["51"] = "=",
			["52"] = ".",
			["58"] = ".",
			["59"] = ".",
			["62"] = "+",
			["63"] = "=",
			["64"] = "=",
			["66"] = "DEL",
			["73"] = "C",
		}
		function window:OnKeyCodePressed( key )
			if keyCodes[tostring( key )] then
				buttons[keyCodes[tostring( key )]]["func"]()	
			end
		end
	end
})