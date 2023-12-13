datapad:AddApp({
	["name"] = "Text editor",
	["icon"] = "datapad/app_icons/text_editor.png",
	["creator"] = "niksacokica",
	["window"] = function( window )
		window:SetPos( ScrW() * 0.25, ScrH() * 0.25 )
		window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
		window:ShowCloseButton( false )
		window:SetTitle( "" )
		window.fileName = "new"
		window.openFile = nil
		window.contentChanged = false
		
		local back_clr = Color( 50, 50, 50 )
		local color_gray = Color( 150, 150, 150 )
		local color_red = Color( 255, 35, 35)
		window.Paint = function( self, w, h )
			surface.SetDrawColor( color_gray )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			surface.SetDrawColor( back_clr )
			surface.DrawRect( 1, 1, w - 2, h - 2 )
			
			draw.SimpleText( self.fileName, "DermaLarge", 10, 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		local cls = vgui.Create( "DButton", window )
		cls:SetPos( ScrW() * 0.5 - 61, 1 )
		cls:SetSize( 60, 40 )
		
		cls.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and color_red or back_clr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.NoTexture()
			surface.SetDrawColor( color_white )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, -45 )
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, w * 0.05, h * 0.5, 45 )
			
			return true
		end
		
		local editor = vgui.Create( "DTextEntry", window )
		editor:Dock( BOTTOM )
		editor:DockMargin( 0, 5, 0, 0 )
		editor:SetSize( 0, ScrH() * 0.5 - 80 )
		editor:SetDrawLanguageID( false )
		editor:SetMultiline( true )
		editor:SetVerticalScrollbarEnabled( true )
		editor:SetPaintBackground(false)
		editor:SetTabbingDisabled( true )
		
		editor.OnChange = function()
			window.contentChanged = true
		end
		
		local oldPaint = editor.Paint
		editor.Paint = function( self, w, h )
			surface.SetDrawColor( color_white )
			surface.DrawRect( 0, 0, w, h )
			
			oldPaint( self, w, h )
		end
		
		window.OpenFile = function( self, filePath )
			self.fileName = string.GetFileFromFilename( filePath )
			self.openFile = filePath
			window.contentChanged = false
			
			editor:SetText( file.Read( filePath, "DATA" ) )
		end
		
		local function selectFile( saveType )
			local fileBrowser = datapad:CreatePopUp( window, "Text editor file selector" )
			fileBrowser:SetSize( ScrW() * 0.25, ScrH() * 0.25 )
			fileBrowser:SetPos( ScrW() * 0.375, ScrH() * 0.375 )
			fileBrowser:ShowCloseButton( false )
			fileBrowser:SetTitle( "" )
			fileBrowser:MakePopup()
			
			fileBrowser.Paint = function( self, w, h )
				surface.SetDrawColor( color_gray )
				surface.DrawOutlinedRect( 0, 0, w, h, 1 )
				
				surface.SetDrawColor( back_clr )
				surface.DrawRect( 1, 1, w - 2, h - 2 )
				
				draw.SimpleText( saveType and "Save file" or "open file", "HudHintTextLarge", 10, 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			local cls = vgui.Create( "DButton", fileBrowser )
			cls:SetPos( ScrW() * 0.228, 1 )
			cls:SetSize( ScrW() * 0.022, ScrH() * 0.03 )
			cls.DoClick = function()
				fileBrowser:Close()
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
			
			local fileSelector = vgui.Create( "DFileBrowser", fileBrowser )
			fileSelector:SetPos( 5, ScrH() * 0.03 + 1 )
			fileSelector:SetSize( ScrW() * 0.25 - 11, ScrH() * 0.192 )
			fileSelector:SetPath( "DATA" )
			fileSelector:SetBaseFolder( "datapad/personal_files" )
			fileSelector:SetName( LocalPlayer():GetName() )
			fileSelector:SetOpen( true )
			
			fileSelector.SetupFiles = function( self )
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
			
			local filename = vgui.Create( "DTextEntry", fileBrowser )
			filename:Dock( BOTTOM )
			filename:DockMargin( 0, 5, ScrW() * 0.05, 0 )
			filename:SetSize( 0, ScrH() * 0.02 )
			filename:SetFont( "ScoreboardDefault" )
			filename:SetDrawLanguageID( false )
			
			local function warningPopUp( text )
				local warning = datapad:CreatePopUp( fileBrowser, "File editor open warning" )
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
			
			local positive = vgui.Create( "DButton", fileBrowser )
			positive:SetText( saveType and "SAVE" or "OPEN" )
			positive:SetPos( ScrW() * 0.202, ScrH() * 0.23 - 4 )
			positive:SetSize( ScrW() * 0.022, ScrH() * 0.02 )
			
			local function open_save()
				local openFile = fileSelector:GetCurrentFolder() .. "/" .. ( filename:GetText() and filename:GetText() or "" )
				
				local function alreadyExists( text )
					local warning = datapad:CreatePopUp( fileBrowser, "File editor exists warning" )
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
					
					local yesWarning = vgui.Create( "DButton", warning )
					yesWarning:SetText( "YES" )
					yesWarning:SetPos( 30, 100 )
					yesWarning:SetSize( 70, 35 )
					yesWarning.DoClick = function()
						file.Write( openFile, editor:GetText() )
						
						if not file.Exists( openFile, "DATA" ) or string.len( filename:GetText() ) == 0 then
							warningPopUp( "The file\"" .. openFile .. "\" has an incorrect name.\nThe filename must end with one of the following: .txt, .dat, .json, .xml, .csv, .jpg, .jpeg, .png, .vtf, .vmt, .mp3, .wav, .ogg! Restricted symbols are: \" :" )
						else
							window.fileName = filename:GetText()
							window.openFile = openFile
							window.contentChanged = false
							
							fileBrowser:Close()
						end
					
						warning:Close()
					end
					
					local noWarning = vgui.Create( "DButton", warning )
					noWarning:SetText( "NO" )
					noWarning:SetPos( 200, 100 )
					noWarning:SetSize( 70, 35 )
					noWarning.DoClick = function()
						warning:Close()
					end
				end
				
				if saveType then
					if string.len( filename:GetText() ) > 0 and file.Exists( openFile, "DATA" ) then
						print("aaaaa")
						alreadyExists( "The file \"" .. openFile .. " already exists.\n Do you want to replace it?" )
					else
						file.Write( openFile, editor:GetText() )
						
						if not file.Exists( openFile, "DATA" ) or string.len( filename:GetText() ) == 0 then
							warningPopUp( "The file\"" .. openFile .. "\" has an incorrect name.\nThe filename must end with one of the following: .txt, .dat, .json, .xml, .csv, .jpg, .jpeg, .png, .vtf, .vmt, .mp3, .wav, .ogg! Restricted symbols are: \" :" )
						else
							window.fileName = filename:GetText()
							window.openFile = openFile
							window.contentChanged = false
							
							fileBrowser:Close()
						end
					end
				else
					if file.Exists( openFile, "DATA" ) and not file.IsDir( openFile, "DATA" ) then
						window:OpenFile( openFile )
						
						fileBrowser:Close()
					else
						warningPopUp( "The file\"" .. openFile .. "\" has not been found.\n Check the name of the file and try again." )
					end
				end
			end
			
			positive.DoClick = open_save
			filename.OnEnter = open_save
			
			local negative = vgui.Create( "DButton", fileBrowser )
			negative:SetText( "CANCEL" )
			negative:SetPos( ScrW() * 0.228 - 5, ScrH() * 0.23 - 4 )
			negative:SetSize( ScrW() * 0.022, ScrH() * 0.02 )
			negative.DoClick = function()
				fileBrowser:Close()
			end
			
			fileSelector.SetCurrentFolder = function( self, strDir )			
				strDir = tostring( strDir )
				strDir = string.Trim( strDir, "/" )

				if ( self.m_strBaseFolder && !string.StartWith( strDir, self.m_strBaseFolder ) ) then
					strDir = string.Trim( self.m_strBaseFolder, "/" ) .. "/" .. string.Trim( strDir, "/" )
				end

				self.m_strCurrentFolder = strDir
				if ( !self.bSetup ) then return end

				self:ShowFolder( strDir )
			end
			
			fileSelector.ShowFolder = function(self, path)
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
						icon:SetDoubleClickingEnabled( true )
						icon.DoClick = function( self )
							filename:SetText( v )
						end
						icon.DoDoubleClick = open_save
					end

				end
				
			end
			
			return fileBrowser
		end
		
		local shortcuts = {}
		
		local function saveChangesPopUp( saveFunction, noSaveFunction )
			local popUp = datapad:CreatePopUp( window, "Text editor save changes" )
			popUp:SetPos( ScrW() * 0.42, ScrH() * 0.42 )
			popUp:SetSize( 300, 150 )
			popUp:SetTitle( "WARNING" )
			popUp:MakePopup()
			popUp:DoModal()

			local popUpText = vgui.Create( "DLabel", popUp )
			popUpText:SetPos( 10, 25 )
			popUpText:SetSize( 280, 70 )
			popUpText:SetWrap( true )
			popUpText:SetText( "Do you wan't to save changes for " .. window.fileName .. "?" )
			
			local popUpSave = vgui.Create( "DButton", popUp )
			popUpSave:SetText( "SAVE" )
			popUpSave:SetPos( 10, 100 )
			popUpSave:SetSize( 70, 35 )
			popUpSave.DoClick = function()
				saveFunction()
				
				popUp:Close()
			end
			
			local popUpNoSave = vgui.Create( "DButton", popUp )
			popUpNoSave:SetText( "DON'T SAVE" )
			popUpNoSave:SetPos( 115, 100 )
			popUpNoSave:SetSize( 70, 35 )
			popUpNoSave.DoClick = function()
					noSaveFunction()
				
				popUp:Close()
			end
			
			local popUpCancel = vgui.Create( "DButton", popUp )
			popUpCancel:SetText( "CANCEL" )
			popUpCancel:SetPos( 220, 100 )
			popUpCancel:SetSize( 70, 35 )
			popUpCancel.DoClick = function()
				popUp:Close()
			end
		end
		
		cls.DoClick = function()
			if window.contentChanged then				
				saveChangesPopUp(
					function()
						local saveAs = shortcuts["saveFile"]()
									
						if saveAs and saveAs:IsValid() then
							local once = true
							saveAs.OnDelete = function()
								if once then
									window:Close()
								end
								
								once = false
							end
						else
							window:Close()
						end
					end,
					function() window:Close() end
				)
			else
				window:Close()
			end
		end
		
		shortcuts = {
			["addDateTime"] = function()
					editor:SetText( editor:GetText() .. os.date( "%H:%M %d.%m.%Y." ) )
				end,
			["newEditor"] = function()
					datapad:StartApp( datapad.apps["text editor"] )
				end,
			["newFile"] = function()
					local function generic()
						if window:IsValid() then						
							window.fileName = "new"
							window.openFile = nil
							window.contentChanged = false
							
							editor:SetText( "" )
						end
					end
			
					if window.contentChanged then						
						saveChangesPopUp(
							function()
								local saveAs = shortcuts["saveFile"]()
								
								if saveAs and saveAs:IsValid() then
									saveAs.OnDelete = generic
								else
									generic()
								end
							end,
							generic
						)
					else
						generic()
					end
				end,
			["openFile"] = function()			
					if window.contentChanged then						
						saveChangesPopUp(
							function()
								local saveAs = shortcuts["saveFile"]()
								
								if saveAs and saveAs:IsValid() then
									local once = true
									saveAs.OnDelete = function()
										if once then
											selectFile()
										end
										
										once = false
									end
								else
									selectFile()
								end
							end,
							selectFile
						)
					else
						selectFile()
					end
				end,
			["saveFile"] = function()
					if window.fileName == "new" then
						return shortcuts["saveFileAs"]()
					else
						file.Write( window.openFile, editor:GetText() )
						
						window.contentChanged = false
					end
				end,
			["saveFileAs"] = function()
					return selectFile( true )
				end
		}
		
		editor.OnKeyCode = function( self, key )
			key = tostring( key )
			
			if input.IsKeyDown( KEY_LCONTROL ) then
				if key == "24" then
					if input.IsKeyDown( KEY_LSHIFT ) then
						shortcuts["newEditor"]()
					else
						shortcuts["newFile"]()
					end
				elseif key == "25" then
					shortcuts["openFile"]()
				elseif key == "29" then
					if input.IsKeyDown( KEY_LSHIFT ) then
						shortcuts["saveFileAs"]()
					else
						shortcuts["saveFile"]()
					end
				end
			end
		end
		
		window.OnKeyCodePressed = function( self, key )		
			key = tostring( key )
		
			print(key)
			if shortcuts[key] then
				shortcuts[key]()
			elseif key == "24" and input.IsKeyDown( KEY_LCONTROL ) then
				if input.IsKeyDown( KEY_LSHIFT ) then
					shortcuts["newEditor"]()
				else
					shortcuts["newFile"]()
				end
			elseif key == "25" and input.IsKeyDown( KEY_LCONTROL ) then
				shortcuts["openFile"]()
			elseif key == "29" and input.IsKeyDown( KEY_LCONTROL ) then
				if input.IsKeyDown( KEY_LSHIFT ) then
					shortcuts["saveFileAs"]()
				else
					shortcuts["saveFile"]()
				end
			end
		end
		
		local file = vgui.Create( "DButton", window )
		file:SetText( "" )
		file:SetPos( 5, 50 )
		file:SetSize( 50, 25 )
		file.DoClick = function( self )
			self.menu = vgui.Create( "DMenu", window )
			
			self.menu:AddOption( "New (Ctrl+N)", function()
				shortcuts["newFile"]()
			end )
			self.menu:AddOption( "New window (Ctrl+Shift+N)", function()
				shortcuts["newEditor"]()
			end )
			self.menu:AddOption( "Open... (Ctrl+O)", function()
				shortcuts["openFile"]()
			end )
			self.menu:AddOption( "Save (Ctrl+S)", function()
				shortcuts["saveFile"]()
			end )
			self.menu:AddOption( "Save as... (Ctrl+Shift+S)", function()
				shortcuts["saveFileAs"]()
			end )
			
			self.menu:AddSpacer()
			
			self.menu:AddOption( "Exit", function()
				window:Close()
			end )
			
			self.menu:Open()
		end
		
		file.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and color_white or back_clr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.SimpleText( "File", "ScoreboardDefault", w * 0.5, h * 0.5, self:IsHovered() and back_clr or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		local edit = vgui.Create( "DButton", window )
		edit:SetText( "" )
		edit:SetPos( 55, 50 )
		edit:SetSize( 50, 25 )
		edit.DoClick = function( self )
			self:FocusPrevious()
			self.menu = vgui.Create( "DMenu", window )
			
			self.menu:AddOption( "Undo (Ctrl+Z)", function()
				editor:Undo()
			end )
			
			self.menu:AddSpacer()
			
			self.menu:AddOption( "Find... (Ctrl+F)", function()

			end )
			self.menu:AddOption( "Find Next (F3)", function()

			end )
			self.menu:AddOption( "Find Previous (Shift+F3)", function()

			end )
			self.menu:AddOption( "Replace... (Ctrl+H)", function()

			end )
			
			self.menu:AddSpacer()
			
			self.menu:AddOption( "Select All (Ctrl+A)", function()
				editor:SelectAll()
			end )
			self.menu:AddOption( "Time/Date (F2)", function()
				shortcuts["addDateTime"]()
			end )

			self.menu:Open()
		end
		
		edit.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and color_white or back_clr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.SimpleText( "Edit", "ScoreboardDefault", w * 0.5, h * 0.5, self:IsHovered() and back_clr or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		local fonts = {
			"BudgetLabel",
			"CenterPrintText",
			"ChatFont",
			"ClientTitleFont",
			"CloseCaption_Bold",
			"CloseCaption_BoldItalic",
			"CloseCaption_Italic",
			"CloseCaption_Normal",
			"CreditsLogo",
			"CreditsOutroLogos",
			"CreditsOutroText",
			"CreditsText",
			"Crosshairs",
			"DebugFixed",
			"DebugFixedSmall",
			"DebugOverlay",
			"Default",
			"DefaultFixed",
			"DefaultFixedDropShadow",
			"DefaultSmall",
			"DefaultUnderline",
			"DefaultVerySmall",
			"DermaDefault",
			"DermaDefaultBold",
			"DermaLarge",
			"GModNotify",
			"HDRDemoText",
			"HL2MPTypeDeath",
			"HudDefault",
			"HudHintTextLarge",
			"HudHintTextSmall",
			"HudNumbers",
			"HudNumbersGlow",
			"HudNumbersSmall",
			"HudSelectionNumbers",
			"HudSelectionText",
			"Marlett",
			"QuickInfo",
			"ScoreboardDefault",
			"ScoreboardDefaultTitle",
			"TargetID",
			"TargetIDSmall",
			"Trebuchet18",
			"Trebuchet24",
			"WeaponIcons",
			"WeaponIconsSelected",
			"WeaponIconsSmall"
		}
		
		local form = vgui.Create( "DButton", window )
		form:SetText( "" )
		form:SetPos( 105, 50 )
		form:SetSize( 80, 25 )
		form.DoClick = function( self )
			self.menu = vgui.Create( "DMenu", window )
			
			local child, _ = self.menu:AddSubMenu( "Font" )
			
			for font in ipairs( fonts ) do
				child.option = child:AddOption( fonts[font], function()					
					editor:SetFont( fonts[font] )
					editor:SetFontInternal( fonts[font] )
				end )
				
				if fonts[font] == editor:GetFont() then
					child.option:SetIcon( "icon16/accept.png" )
				end
			end

			self.menu:Open()
		end
		
		form.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and color_white or back_clr )
			surface.DrawRect( 0, 0, w, h )
			
			draw.SimpleText( "Format", "ScoreboardDefault", w * 0.5, h * 0.5, self:IsHovered() and back_clr or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
})