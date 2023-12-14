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
			surface.DrawRect( 1, 1, w - 2, h - 2 )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetPos( ScrW() * 0.328, 1 )
		cls:SetSize( ScrW() * 0.022, ScrH() * 0.028 )
		cls.DoClick = function()
			window:Close()
		end
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and color_red or back_clr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.NoTexture()
			surface.SetDrawColor( color_white )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, 45 )
			
			return true
		end
		
		local browser = vgui.Create( "DFileBrowser", window )
		browser:SetPos( ScrW() * 0.0005, ScrH() * 0.029 )
		browser:SetSize( ScrW() * 0.3495, ScrH() * 0.3205 )

		browser.SetupFiles = function( self )
			if ( IsValid( self.Files ) ) then self.Files:Remove() end

			self.Files = self.Divider:Add( "DTileLayout" )
			self.Files:SetBaseSize(32)
			self.Files:SetBackgroundColor( Color( 234, 234, 234 ) )
			self.Files:MakeDroppable( "FilesContentPanel", true )

			self.Divider:SetRight( self.Files )

			if ( self.m_strCurrentFolder and self.m_strCurrentFolder != "" ) then
				self:ShowFolder( self.m_strCurrentFolder )
			end

			return true
		end
		
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
			local warning = datapad:CreatePopUp( window, "File explorer warning" )
			warning:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			warning:SetSize( 300, 150 )
			warning:SetTitle( "WARNING" )
			warning:MakePopup()
			warning:DoModal()

			local warningText = vgui.Create( "DLabel", warning )
			warningText:SetPos( 10, 25 )
			warningText:SetSize( 280, 70 )
			warningText:SetWrap( true )
			warningText:SetText( text )
			
			local okWarning = vgui.Create( "DButton", warning )
			okWarning:SetText( "OK" )
			okWarning:SetPos( 115, 100 )
			okWarning:SetSize( 70, 35 )
			okWarning.DoClick = function()
				warning:Close()
			end
		end
		
		local function addPopUp( curPath, title, rnm, folder )
			local popUp = datapad:CreatePopUp( window, "File explorer PopUp" )
			popUp:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			popUp:SetSize( 300, 150 )
			popUp:SetTitle( title )
			popUp:MakePopup()
			popUp:DoModal()

			local name = vgui.Create( "DTextEntry", popUp )
			name:SetPos( 10, 40 )
			name:SetSize( 280, 35 )
			name:SetFont( "DermaLarge" )
			name:SetDrawLanguageID( false )
			
			local cancel = vgui.Create( "DButton", popUp )
			cancel:SetText( "CANCEL" )
			cancel:SetPos( 20, 100 )
			cancel:SetSize( 75, 30 )
			cancel.DoClick = function()
				popUp:Close()
			end
			
			if rnm then
				name:SetText( string.GetFileFromFilename( rnm ) )
			
				local ren = vgui.Create( "DButton", popUp )
				ren:SetText( "RENAME" )
				ren:SetPos( 205, 100 )
				ren:SetSize( 70, 30 )
				ren.DoClick = function()
					if not file.Rename( rnm, string.GetPathFromFilename( rnm ) .. name:GetText() ) then
						warningPopUp( "The filename must end with one of the following: .txt, .dat, .json, .xml, .csv, .jpg, .jpeg, .png, .vtf, .vmt, .mp3, .wav, .ogg! Restricted symbols are: \" :" )
					else
						browser:Refresh()
					end
					
					popUp:Close()
				end
			else				
				local add = vgui.Create( "DButton", popUp )
				add:SetText( "ADD" )
				add:SetPos( 205, 100 )
				add:SetSize( 75, 30 )
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
		end
		
		browser.ShowFolder = function(self, path)
			if ( !IsValid( self.Files ) ) then return end
			self.Files:Clear()

			if ( IsValid( self.FileHeader ) ) then
				self.FileHeader:SetText( path || "Files" )
			end

			if ( !path ) then return end

			local filters = self.m_strFilter
			if ( !filters || filters == "" ) then
				filters = "*.*"
			end

			for _, filter in ipairs( string.Explode( " ", filters ) ) do
				local files = file.Find( string.Trim( path .. "/" .. ( filter || "*.*" ), "/" ), self.m_strPath )
				if ( !istable( files ) ) then continue end

				for _, v in ipairs( files ) do
					local icon = self.Files:Add( "ContentIcon" )
					icon:SetMaterial( "datapad/files/doc_" .. string.GetExtensionFromFilename( v ) .. ".png" )
					icon:SetName( v )
					icon.DoRightClick = function( self )
						local menu = vgui.Create( "DMenu", window )
						
						menu:AddOption( "Open", function()
							local text_editor = datapad:StartApp( datapad.apps["text editor"] )
							text_editor:OpenFile( browser:GetCurrentFolder() .. "/" .. v )
						end )
						menu:AddOption( "Rename", function()
							addPopUp( nil, "File Rename", browser:GetCurrentFolder() .. "/" .. v )
						end ) 
						
						menu:Open()
					end
				end

			end
		end
		
		browser:Refresh()
		
		local function addIcon( posX, posY, sizeX, sizeY, iconPath, func )
			local icon = vgui.Create( "DButton", window )
			icon:SetPos( posX, posY )
			icon:SetSize( sizeX, sizeY )
			icon.DoClick = func
			
			local iconMat = Material( iconPath )
			icon.Paint = function( self, w, h )
				draw.NoTexture()
			
				surface.SetMaterial( iconMat )
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect( 0, 0, w, h )
				
				return true
			end
		end
		
		addIcon( ScrW() * 0.005, ScrH() * 0.005, ScrH() * 0.02, ScrH() * 0.02, "icon16/arrow_rotate_anticlockwise.png",
		function()
			browser:Refresh()
		end )
		
		addIcon( ScrW() * 0.02, ScrH() * 0.005, ScrH() * 0.02, ScrH() * 0.02, "icon16/folder_add.png",
		function()
			local curPath = browser:GetCurrentFolder()
		
			if curPath then
				addPopUp( curPath, "New Folder", false, true )
			end
		end )
		
		local function delPopUp( curPath, title, folder )
			local popUp = datapad:CreatePopUp( window, "File explorer delete" )
			popUp:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			popUp:SetSize( 300, 150 )
			popUp:SetTitle( title )
			popUp:MakePopup()
			
			popUp.Think = function( self )			
				self:MoveToFront()
			end
			
			local delText = vgui.Create( "DLabel", popUp )
			delText:SetPos( 10, 25 )
			delText:SetSize( 280, 50 )
			delText:SetWrap( true )
			delText:SetText( "Are you sure you want to delete \"" .. curPath .. "\" and all of its contents?" )
			
			local cancel = vgui.Create( "DButton", popUp )
			cancel:SetText( "CANCEL" )
			cancel:SetPos( 20, 100 )
			cancel:SetSize( 75, 30 )
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
			del:SetPos( 205, 100 )
			del:SetSize( 75, 30 )
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
				addPopUp( curPath, "New File", false, false )
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
		searchEntry:SetDrawLanguageID( false )
		searchEntry.OnEnter = function( self, value )
			browser:SetSearch( value )
		end
		
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