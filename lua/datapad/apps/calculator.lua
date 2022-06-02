surface.CreateFont( "NumberFont", {
	font = "Roboto",
	size = 64
})

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
		
		local nums = vgui.Create( "DLabel", window )
		nums:SetPos( ScrW() * 0.003, ScrH() * 0.06 )
		nums:SetText( "0" )
		nums:SetFont( "NumberFont" )
		nums:SetTextColor( color_black )
		nums:SetSize( ScrW() * 0.165, ScrH() * 0.04 )
		nums:SetContentAlignment( 6 )
		nums.result = false
		
		function nums:AppendChar( num )
			local txt = nums:GetText()
			if #txt > 9 or ( ( string.find( txt, "%." ) or not tonumber( string.Replace( txt, ",", "" ) ) ) and num == "." ) then return end
			
			if ( txt == "0" or not tonumber( string.Replace( txt, ",", "" ) ) ) and not ( num == "." ) or nums.result then
				nums.result = false
				nums:SetText( num )
			else
				nums:SetText( string.Comma( string.Replace( txt, ",", "" ) .. num ) )
			end
		end
		
		function nums:RemoveChar( num )
			local txt = nums:GetText()
			if txt == "0" then return end
			
			if #txt == 1 or ( #txt == 2 and txt[1] == "-" ) or num == #txt then
				nums:SetText( "0" )
			else
				nums:SetText( string.Comma( string.Replace( string.Left( txt , #txt - num ), ",", "" ) ) )
			end
		end
		
		function nums:ToggleSign()
			local txt = nums:GetText()
			if txt == "0" then return end
			
			if not ( txt[1] == "-" ) then
				nums:SetText( "-" .. txt )
			else
				nums:SetText( string.Comma( string.Replace( string.Right( txt , #txt - 1 ), ",", "" ) ) )
			end
		end
		
		local clrGrey = Color( 242, 242, 242 )
		local buttons = {
			{
				["name"] = "%",
				["clr"] = clrGrey
			},
			{
				["name"] = "CE",
				["clr"] = clrGrey,
				["func"] = function()
					nums:RemoveChar( #nums:GetText() )
				end
			},
			{
				["name"] = "C",
				["clr"] = clrGrey
			},
			{
				["name"] = "DEL",
				["clr"] = clrGrey,
				["func"] = function()
					nums:RemoveChar( 1 )
				end
			},
			
			{
				["name"] = "1/X",
				["clr"] = clrGrey
			},
			{
				["name"] = "x²",
				["clr"] = clrGrey,
				["func"] = function()
					local num = string.Replace( nums:GetText(), ",", "" )
					if not tonumber( num ) then return end
					
					nums.result = true
					local res = tostring( num * num )
					
					if not tonumber( res ) then
						nums:SetText( res )
					else
						if #res > 9 then
							nums:SetText( string.Comma( string.sub( res, 1, #res - 9 ) ) )
						else
							nums:SetText( string.Comma( res ) )
						end
					end
				end
			},
			{
				["name"] = "2√X",
				["clr"] = clrGrey,
				["func"] = function()
					local num = string.Replace( nums:GetText(), ",", "" )
					if not tonumber( num ) then return end
				
					local res = tostring( math.sqrt( num ) )
					nums.result = true
					
					if tonumber( res ) then
						nums:SetText( string.Comma( math.Round( res, math.min( #res, math.abs( #res - 10 ) ) ) ) )
					else
						nums:SetText( res )
					end
				end
			},
			{
				["name"] = "/",
				["clr"] = clrGrey
			},
			
			{
				["name"] = "7",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 7 )
				end
			},
			{
				["name"] = "8",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 8 )
				end
			},
			{
				["name"] = "9",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 9 )
				end
			},
			{
				["name"] = "X",
				["clr"] = clrGrey
			},
			
			{
				["name"] = "4",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 4 )
				end
			},
			{
				["name"] = "5",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 5 )
				end
			},
			{
				["name"] = "6",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 6 )
				end
			},
			{
				["name"] = "-",
				["clr"] = clrGrey
			},
			
			{
				["name"] = "1",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 1 )
				end
			},
			{
				["name"] = "2",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 2 )
				end
			},
			{
				["name"] = "3",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 3 )
				end
			},
			{
				["name"] = "+",
				["clr"] = clrGrey
			},
			
			{
				["name"] = "+/-",
				["clr"] = color_white,
				["func"] = function()
					nums:ToggleSign()
				end
			},
			{
				["name"] = "0",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( 0 )
				end
			},
			{
				["name"] = ".",
				["clr"] = color_white,
				["func"] = function()
					nums:AppendChar( "." )
				end
			},
			{
				["name"] = "=",
				["clr"] = Color( 153, 204, 234 )
			}
		}
		
		local grid = vgui.Create( "DGrid", window )
		grid:SetPos( ScrW() * 0.0025, ScrH() * 0.124 )
		grid:SetCols( 4 )
		grid:SetColWide( ScrW() * 0.0417 )
		grid:SetRowHeight( ScrW() * 0.0323 )
		
		for k, v in ipairs( buttons ) do
			local but = vgui.Create( "DButton" )
			but:SetFont( "DermaLarge" )
			but:SetText( v["name"] )
			but:SetSize( ScrW() * 0.041, ScrH() * 0.056 )
			
			grid:AddItem( but )
			
			local hvrg = Color( 200, 200, 200 )
			local hvrb = Color( 95, 185, 238 )
			local pvrg = Color( 175, 175, 175 )
			local pvrb = Color( 38, 166, 242 )
			but.UpdateColours = function( self, skin ) end
			but.Paint = function( self, w, h )
				surface.SetDrawColor( ( but:IsDown() and ( v["name"] == "=" and pvrb or pvrg ) or ( but:IsHovered() and ( v["name"] == "=" and hvrb or hvrg ) or v["clr"] ) ):Unpack() )
				surface.DrawRect( 0, 0, w, h )
			end
			but.DoClick = v["func"]
		end
	end
})