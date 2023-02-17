local function PopUp( window, path, text )
	local popup = vgui.Create( "DFrame", window )
	popup:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
	popup:SetSize( ScrW() * 0.1, ScrH() * 0.1 )
	popup:SetTitle( "Notepad" )
	popup:MakePopup()
	popup:ShowCloseButton( false )
	
	popup.Think = function( self )
		self:MoveToFront()
	end

	local ptext = vgui.Create( "DLabel", popup )
	ptext:SetPos( ScrW() * 0.005, ScrH() * 0.022 )
	ptext:SetSize( ScrW() * 0.09, ScrH() * 0.04 )
	ptext:SetWrap(true)
	ptext:SetText( "Do you want to save changes to ".. tostring(path) .."?" )
	
	local confirm = vgui.Create( "DButton", popup )
	confirm:SetText( "Yes" )
	confirm:SetPos( ScrW() * 0.02, ScrH() * 0.07 )
	confirm:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
	confirm.DoClick = function()
		if path == "newfile" then
			file.Write( "datapad/personal_files/desktop/" .. os.date( "%d-%m-%Y_%H-%M-%S" ) .. ".txt", text )
		else
			file.Write( path, text )
		end
		popup:Close()
		window:Close()
		clicked = false
	end
	local close = vgui.Create( "DButton", popup )
	close:SetText( "No" )
	close:SetPos( ScrW() * 0.050, ScrH() * 0.07 )
	close:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
	close.DoClick = function()
		popup:Close()
		window:Close()
		clicked = false
	end
end
function Notepad( window, path )
	local clicked = false
	window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
	window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
	window:ShowCloseButton( false )
	window.title = "Notepad"
	
	local back_clr = Color( 50, 50, 50 )
	local color_gray = Color( 150, 150, 150 )
	local color_red = Color( 255, 35, 35)
	window.Paint = function( self, w, h )
		surface.SetDrawColor( back_clr )
		surface.DrawRect( w * 0.001, h * 0.002, w * 0.999, h * 0.998 )

		surface.SetDrawColor( color_white )
		surface.DrawRect( w * 0.001, h * 0.003, w * 0.999, h * 0.1 )
		
		surface.SetFont( "DermaDefaultBold" )
		surface.SetTextColor( color_black )
		surface.SetTextPos( w * 0.05, h * 0.022 ) 
		surface.DrawText( window.title )
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( Material( "datapad/app_icons/text_editor.png" ) )
		surface.DrawTexturedRect( w * 0.01, h * 0.015, w * 0.03, h * 0.05 )
	end

	local text = vgui.Create( "DTextEntry", window )
	text:SetPos( ScrW() * 0.001, ScrH() * 0.052 )
	text:SetSize( ScrW() * 0.499, ScrH() * 0.448 )
	text:SetMultiline( true )
	text:SetFont( "DermaDefaultBold" )
	text:SetTextColor( color_white )
	text:SetDrawBackground( false )
	text:SetDrawBorder( false )
	text:SetVerticalScrollbarEnabled( true )
	text:SetAllowNonAsciiCharacters( true )
	text:SetUpdateOnType( true )
	text:SetHighlightColor( color_white )
	text:SetCursorColor( color_white )
	text:SetEditable( true )
	if path == "newfile" then
	else
		text:SetText( file.Read( path ) )
	end

	local cls = vgui.Create( "DButton", window )
	cls:SetText( "" )
	cls:SetPos( ScrW() * 0.478, ScrH() * 0.001 )
	cls:SetSize( ScrW() * 0.022, ScrH() * 0.028 )
	cls.DoClick = function()
		if clicked == false then
			clicked = true
			PopUp( window, path, text:GetText() )
		end
	end

	cls.Paint = function( self, w, h )
		surface.SetDrawColor( cls:IsHovered() and color_red or color_white )
		surface.DrawRect( 0, 0, w, h )
		
		draw.NoTexture()
		surface.SetDrawColor(color_black)
		surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, -45 )
		surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, 45 )
	end

	local grid = vgui.Create( "DGrid", window )
	grid:Dock(TOP)
	grid:DockPadding( 0, 50, 0, 0 )
	grid:SetCols( 3 )
	grid:SetColWide( ScrW() * 0.07 )
	grid:SetRowHeight( ScrH() * 0.028 )	

	local option_file = vgui.Create( "DButton", window )
	option_file:SetText( "File" )
	option_file:SetPos( ScrW() * 0.001, ScrH() * 0.034 )
	option_file:SetSize( ScrW() * 0.03, ScrH() * 0.015 )
	option_file.DoClick = function()
		local menu = vgui.Create( "DMenu", window )
		menu:AddOption( "New Window", function()
			datapad:StartApp( datapad.apps["notepad"] )
		end )
		menu:AddOption( "Open...", function()
		end ) 
		menu:AddOption( "Save", function()
			if path == "newfile" then
				file.Write( "data/datapad/notepad/" .. os.date( "%d-%m-%Y_%H-%M-%S" ) .. ".txt", text:GetText() )
			else
				file.Write( path, text:GetText() )
			end
		end )
		menu:AddOption( "Save As...", function()
		end )
		menu:AddOption( "Exit", function()
			window:Close()
		end )
		menu:Open()
	end
	grid:AddItem( option1 )
end

datapad:AddApp({
	["name"] = "Notepad",
	["icon"] = "datapad/app_icons/text_editor.png",
	["creator"] = "TheWander02",
	["window"] = function( window )
		Notepad( window, "newfile" )
	end
})