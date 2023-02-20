datapad:AddApp({
	["name"] = "File Explorer",
	["icon"] = "datapad/app_icons/file_explorer.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.3, ScrH() * 0.3 )
		window:SetSize( ScrW() * 0.35, ScrH() * 0.35 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		
		local back_clr = Color( 50, 50, 50 )
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35)
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( w * 0.002, h * 0.002, w * 0.998, h * 0.08 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetText( "" )
		cls:SetPos( ScrW() * 0.328, ScrH() * 0.001 )
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
		
		local browser = vgui.Create( "DFileBrowser", window )
		browser:SetPos( ScrW() * 0.0005, ScrH() * 0.029 )
		browser:SetSize( ScrW() * 0.3495, ScrH() * 0.3205 )
		
		browser.Refresh = function( self )
			if not file.Exists( "datapad/personal_files/appdata", "DATA" ) then
				file.CreateDir( "datapad/personal_files/appdata" )
			end
			if not file.Exists( "datapad/personal_files/desktop", "DATA" ) then
				file.CreateDir( "datapad/personal_files/desktop" )
			end
			if not file.Exists( "datapad/personal_files/documents", "DATA" ) then
				file.CreateDir( "datapad/personal_files/documents" )
			end
		
			local lastOpen = self:GetCurrentFolder()
		
			self:Clear()
			self:SetPath( "DATA" )
			self:SetBaseFolder( "datapad/personal_files" )
			self:SetName( LocalPlayer():GetName() )
			self:SetOpen( true )
			
			if lastOpen then
				self:SetCurrentFolder( lastOpen )
			end
		end
		
		browser.OnSelect = function( self, path, pnl )
			self.lastFile = path
		end
		
		local function warningPopUp( text )
			local warning = vgui.Create( "DFrame", window )
			warning:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			warning:SetSize( ScrW() * 0.1, ScrH() * 0.1 )
			warning:SetTitle( "WARNING" )
			warning:MakePopup()
			
			warning.Think = function( self )
				self:MoveToFront()
			end

			local warningText = vgui.Create( "DLabel", warning )
			warningText:SetPos( ScrW() * 0.005, ScrH() * 0.022 )
			warningText:SetSize( ScrW() * 0.09, ScrH() * 0.04 )
			warningText:SetWrap(true)
			warningText:SetText( text )
			
			local okWarning = vgui.Create( "DButton", warning )
			okWarning:SetText( "OK" )
			okWarning:SetPos( ScrW() * 0.035, ScrH() * 0.07 )
			okWarning:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
			okWarning.DoClick = function()
				warning:Close()
			end
		end
		
		browser.OnRightClick = function( self, path, pnl )
			local popUp = vgui.Create( "DFrame", window )
			popUp:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			popUp:SetSize( ScrW() * 0.1, ScrH() * 0.1 )
			popUp:SetTitle( "File Rename" )
			popUp:MakePopup()
			
			popUp.Think = function( self )			
				self:MoveToFront()
			end
			
			local renText = vgui.Create( "DTextEntry", popUp )
			renText:SetPos( ScrW() * 0.005, ScrH() * 0.022 )
			renText:SetSize( ScrW() * 0.09, ScrH() * 0.04 )
			renText:SetFont( "DermaLarge" )
			renText:SetText( string.GetFileFromFilename( path ) )
			
			local cancel = vgui.Create( "DButton", popUp )
			cancel:SetText( "CANCEL" )
			cancel:SetPos( ScrW() * 0.005, ScrH() * 0.07 )
			cancel:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
			cancel.DoClick = function()
				popUp:Close()
			end
			
			local ren = vgui.Create( "DButton", popUp )
			ren:SetText( "RENAME" )
			ren:SetPos( ScrW() * 0.065, ScrH() * 0.07 )
			ren:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
			ren.DoClick = function()
				if not file.Rename( path, string.GetPathFromFilename( path ) .. renText:GetText() ) then
					warningPopUp( "The filename must end with one of the following: .txt, .dat, .json, .xml, .csv, .jpg, .jpeg, .png, .vtf, .vmt, .mp3, .wav, .ogg! Restricted symbols are: \" :" )
				else
					browser:Refresh()
				end
				
				popUp:Close()
			end
		end
		
		browser:Refresh()
		
		local function addIcon( posX, posY, sizeX, sizeY, iconPath, func )
			local icon = vgui.Create( "DButton", window )
			icon:SetText( "" )
			icon:SetPos( posX, posY )
			icon:SetSize( sizeX, sizeY )
			icon.DoClick = func
			
			local iconMat = Material( iconPath )
			icon.Paint = function( self, w, h )
				draw.NoTexture()
			
				surface.SetMaterial( iconMat )
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect( 0, 0, w, h )
			end
		end
		
		addIcon( ScrW() * 0.005, ScrH() * 0.005, ScrH() * 0.02, ScrH() * 0.02, "icon16/arrow_rotate_anticlockwise.png",
		function()
			browser:Refresh()
		end )
		
		local function addPopUp( curPath, title, folder )
			local popUp = vgui.Create( "DFrame", window )
			popUp:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			popUp:SetSize( ScrW() * 0.1, ScrH() * 0.1 )
			popUp:SetTitle( title )
			popUp:MakePopup()

			local name = vgui.Create( "DTextEntry", popUp )
			name:SetPos( ScrW() * 0.002, ScrH() * 0.022 )
			name:SetSize( ScrW() * 0.096, ScrH() * 0.025 )
			name:SetFont( "DermaLarge" )
			
			local cancel = vgui.Create( "DButton", popUp )
			cancel:SetText( "CANCEL" )
			cancel:SetPos( ScrW() * 0.005, ScrH() * 0.066 )
			cancel:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
			cancel.DoClick = function()
				popUp:Close()
			end
			
			local add = vgui.Create( "DButton", popUp )
			add:SetText( "ADD" )
			add:SetPos( ScrW() * 0.065, ScrH() * 0.066 )
			add:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
			add.DoClick = function()			
				if #name:GetText() == 0 then
					warningPopUp( folder and "Folder name is empty!" or "File name is empty!" )
				elseif file.Exists( curPath .. "/" .. name:GetText(), "DATA" ) then
					warningPopUp( folder and "Folder already exists!" or "File already exists!" )
				else
					if folder then
						file.CreateDir( curPath .. "/" .. name:GetText() )
					else
						file.Write( curPath .. "/" .. name:GetText(), "" )
						
						if not file.Exists( curPath .. "/" .. name:GetText(), "DATA" ) then
							warningPopUp( "The filename must end with one of the following: .txt, .dat, .json, .xml, .csv, .jpg, .jpeg, .png, .vtf, .vmt, .mp3, .wav, .ogg! Restricted symbols are: \" :" )
						end
					end
					
					browser:Refresh()
				end
				
				popUp:Close()
			end
		end
		
		addIcon( ScrW() * 0.02, ScrH() * 0.005, ScrH() * 0.02, ScrH() * 0.02, "icon16/folder_add.png",
		function()
			local curPath = browser:GetCurrentFolder()
		
			if curPath then
				addPopUp( curPath, "New Folder", true )
			end
		end )
		
		local function delPopUp( curPath, title, folder )
			local popUp = vgui.Create( "DFrame", window )
			popUp:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			popUp:SetSize( ScrW() * 0.1, ScrH() * 0.1 )
			popUp:SetTitle( title )
			popUp:MakePopup()
			
			popUp.Think = function( self )			
				self:MoveToFront()
			end
			
			local delText = vgui.Create( "DLabel", popUp )
			delText:SetPos( ScrW() * 0.005, ScrH() * 0.022 )
			delText:SetSize( ScrW() * 0.09, ScrH() * 0.04 )
			delText:SetWrap(true)
			delText:SetText( "Are you sure you want to delete \"" .. curPath .. "\" and all of its contents?" )
			
			local cancel = vgui.Create( "DButton", popUp )
			cancel:SetText( "CANCEL" )
			cancel:SetPos( ScrW() * 0.005, ScrH() * 0.066 )
			cancel:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
			cancel.DoClick = function()
				popUp:Close()
			end
			
			local function delAll( path )
				local files, dirs = file.Find( path .. "/*", "DATA" )
				
				for k, v in ipairs( files ) do
					file.Delete( path .. "/" .. v )
				end
				
				for k, v in ipairs( dirs ) do
					delAll( path .. "/" .. v )
					file.Delete( path .. "/" .. v )
				end
			end
			
			local del = vgui.Create( "DButton", popUp )
			del:SetText( "DELETE" )
			del:SetPos( ScrW() * 0.065, ScrH() * 0.066 )
			del:SetSize( ScrW() * 0.03, ScrH() * 0.02 )
			del.DoClick = function()
				delAll( curPath )
				file.Delete( curPath )
				
				browser:Refresh()
				popUp:Close()
			end
		end
		
		addIcon( ScrW() * 0.036, ScrH() * 0.005, ScrH() * 0.02, ScrH() * 0.02, "icon16/folder_delete.png",
		function()
			local curPath = browser:GetCurrentFolder()
		
			if curPath then
				delPopUp( curPath, "Delete Folder", true )
			end
		end )
		
		addIcon( ScrW() * 0.052, ScrH() * 0.005, ScrH() * 0.02, ScrH() * 0.02, "icon16/page_white_add.png",
		function()
			local curPath = browser:GetCurrentFolder()
		
			if curPath then
				addPopUp( curPath, "New File", false )
			end
		end )
		
		addIcon( ScrW() * 0.068, ScrH() * 0.005, ScrH() * 0.02, ScrH() * 0.02, "icon16/page_white_delete.png",
		function()
			local curPath = browser:GetCurrentFolder()
		
			if curPath and browser.lastFile and file.Exists( browser.lastFile, "DATA" ) and curPath == string.TrimRight( string.GetPathFromFilename( browser.lastFile ), "/" ) then
				delPopUp( browser.lastFile, "Delete File", false )
			end
		end )
		
		local searchEntry = vgui.Create( "DTextEntry", window )
		searchEntry:SetPos( ScrW() * 0.1, ScrH() * 0.007 )
		searchEntry:SetSize( ScrW() * 0.1, ScrH() * 0.017 )
		searchEntry:SetFont( "DermaDefault" )
		
		addIcon( ScrW() * 0.203, ScrH() * 0.006, ScrH() * 0.02, ScrH() * 0.02, "icon16/magnifier.png",
		function()
			browser:SetSearch( searchEntry:GetText() )
		end )
		
		addIcon( ScrW() * 0.217, ScrH() * 0.006, ScrH() * 0.02, ScrH() * 0.02, "icon16/arrow_switch.png",
		function()
			browser.sort = not browser.sort
			browser:SortFiles( browser.sort )
		end )
	end
})