datapad = istable( datapad ) and datapad or {}
datapad.devMode = nil

if not file.Exists( "datapad/personal_files/appdata", "DATA" ) then
	file.CreateDir( "datapad/personal_files/appdata" )
end
if not file.Exists( "datapad/personal_files/desktop", "DATA" ) then
	file.CreateDir( "datapad/personal_files/desktop" )
end
if not file.Exists( "datapad/personal_files/documents", "DATA" ) then
	file.CreateDir( "datapad/personal_files/documents" )
end

function datapad:AddApp( app )
	self.apps = istable( self.apps ) and self.apps or {}
	
	local hookReturn = hook.Run( "DatapadAddApp", app )
	
	if #app["name"] == 0 then
		return
	elseif istable( self.apps[app["name"]] ) and not datapad.devMode then
		ErrorNoHalt( "App with the name  '" .. app["name"] .. "'  already exists!" )
	elseif not hookReturn then
		self.apps[string.lower( app["name"] )] = app
	end
end

function datapad:StartApp( v )
	local hookReturn = hook.Run( "DatapadPreAppStart", v )
	if hookReturn or #self.OpenApps >= math.floor( ( ScrW() - 250 ) / 40 ) then return end

	local window = vgui.Create( "DFrame", self.screen )
	window:Center()
	window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
	window:MakePopup()
	
	local function handleWindowClose()
		if not window:IsValid() then return end
	
		if window.OnDelete then
			window:OnDelete()
		end
		
		for key, val in ipairs( self.OpenApps ) do
			if val[2] == v["name"] and val[1] == window then
				table.remove( self.OpenApps, key )
				
				hook.Run( "DatapadAppClosed", v )
				return
			end
		end
	end
	
	function window:OnClose()	
		handleWindowClose()
	end
	function window:OnRemove()
		handleWindowClose()
	end
	
	table.insert( self.OpenApps, { window, v["name"], v["icon"] } )
	v["window"]( window )
	
	hook.Run( "DatapadPostAppStart", v, window )
	
	return window
end

function datapad:CreatePopUp( parent, name, icon )
	local hookReturn = hook.Run( "DatapadPrePopUpStart", parent, name, icon )
	if hookReturn or #self.OpenApps >= math.floor( ( ScrW() - 250 ) / 40 ) then return end
	
	local windowName = isstring( name ) and name or "Generic PopUp"
	local windowIcon = isstring( icon ) and icon or "datapad/app_icons/default_popup.png"
	
	local window = vgui.Create( "DFrame", parent )
	window.isPopUp = true
	
	local function handleWindowClose()
		if window.OnDelete then
			window:OnDelete()
		end
		
		for key, val in ipairs( self.OpenApps ) do
			if val[2] == windowName and val[1] == window then
				table.remove( self.OpenApps, key )
				
				hook.Run( "DatapadPopUpClosed", parent, windowName, windowIcon )
				return
			end
		end
	end
	
	function window:OnClose()	
		handleWindowClose()
	end
	function window:OnRemove()
		handleWindowClose()
	end
	
	table.insert( self.OpenApps, { window, windowName, windowIcon } )
	
	hook.Run( "DatapadPostPopUpStart", window, parent, windowName, windowIcon )
	return window
end

local function populateApps( grid )
	local hookReturn = hook.Run( "DatapadPreAppPopulate", datapad.apps )
	if hookReturn then return end

	for k, v in SortedPairs( datapad.apps ) do
		local app = vgui.Create( "DButton" )
		app:SetSize( grid:GetColWide()*0.8, grid:GetRowHeight()*0.8 )
		app.DoDoubleClick = function()
			datapad:StartApp( v )
		end
		
		local app_icon = Material( v["icon"] )
		app.Paint = function( self, w, h )
			surface.SetDrawColor( color_white )
			surface.SetMaterial( app_icon )
			surface.DrawTexturedRect( 0, 0, w, h )
			
			return true
		end
		
		if #grid:GetItems() < 50 then
			grid:AddItem( app )
		end
	end
	
	hook.Run( "DatapadPostAppPopulate", datapad.apps )
end

local function taskBar( background )
	local hookReturn = hook.Run( "DatapadPreTaskBar" )
	if hookReturn then return end
	
	local bar = vgui.Create( "DPanel", background )
	bar:SetPos( 0, 0 )
	bar:SetSize( ScrW(), 50 )
	bar:SetPaintBackground( true )
	bar:MakePopup()
	bar:SetPopupStayAtBack( true )
	
	local cls = vgui.Create( "DButton", bar )
	cls:Dock(LEFT)
	cls:DockMargin(3, 3, 0, 3)
	cls:SetSize( 45, 0 )
	cls.DoClick = function()
		background:Remove()
	end
	
	local iconMat = Material( "datapad/other/exit.png" )
	cls.Paint = function( self, w, h )
		draw.NoTexture()
	
		surface.SetMaterial( iconMat )
		surface.DrawTexturedRect( 0, 0, w, h )
		
		return true
	end
	
	local openApps = vgui.Create( "DGrid", bar )
	openApps:Dock(FILL)
	openApps:DockMargin( 5, 5, 5, 0 )
	openApps:SetCols( math.floor( ( ScrW() - 250 ) / 40 ) )
	openApps:SetColWide( 40 )
	openApps:SetRowHeight( 40 )
	datapad.TaskBar = openApps
	
	local function fillTaskBar()
		if not IsValid( datapad.TaskBar ) then return end
		datapad.TaskBar:Clear()
		datapad.TaskBar.Items = {}
	
		for k, v in ipairs( datapad.OpenApps ) do		
			local openApp = vgui.Create( "DButton" )
			openApp:SetColor( color_black )
			openApp:SetSize( 40, 40 )
			
			local out_clr = Color( 100, 100, 100 )
			local in_clr = Color( 200, 200, 200 )
			local in_clr_sel = Color( 150, 150, 150 )
			local ico = Material( v[3] )
			openApp.Paint = function( self, w, h )
				local childWithFocus = nil
				for j, l in ipairs(v[1]:GetChildren()) do
					if l:HasFocus() then
						childWithFocus = l
					
						break
					end
				end
			
				if v[1]:HasFocus() or ( childWithFocus and not childWithFocus.isPopUp ) then
					surface.SetDrawColor( out_clr:Unpack() )
					surface.DrawOutlinedRect( 0, 0, w, h, 2 )
				end
				
				draw.NoTexture()
	
				surface.SetMaterial( ico )
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect( 1, 1, w - 1, h - 1 )
				
				return true
			end
			
			openApp.DoClick = function()
				v[1]:MoveToFront()
			end
			
			datapad.TaskBar:AddItem( openApp )
		end
	end
	
	hook.Add( "DatapadPostAppStart", "DatapadAddAppToTaskBar", fillTaskBar )
	hook.Add( "DatapadAppClosed", "DatapadRemoveAppFromTaskBar", fillTaskBar )
	hook.Add( "DatapadPostPopUpStart", "DatapadAddPopUpToTaskBar", fillTaskBar )
	hook.Add( "DatapadPopUpClosed", "DatapadRemovePopUpFromTaskBar", fillTaskBar )
	
	local dateTime = vgui.Create( "DLabel", bar )
	dateTime:Dock(RIGHT)
	dateTime:DockMargin( 0, (1440/ScrH())^2*2.5, 10, 0 )
	dateTime:SetSize( 125, 0 )
	
	local curTime = os.date( "%H:%M\n%d.%m.%Y" )
	local dtmr = CurTime() + 1
	dateTime.Paint = function( self, w, h )
		if dtmr < CurTime() then
			curTime = os.date( "%H:%M\n%d.%m.%Y" )
		
			dtmr = CurTime() + 1
		end
	
		draw.DrawText( curTime, "ChatFont", w*0.5, 0, color_black, TEXT_ALIGN_CENTER )
		
		return true
	end
	
	local ping = vgui.Create( "DLabel", bar )
	ping:Dock(RIGHT)
	ping:DockMargin(0, 3, 10, 3)
	ping:SetSize( 75, 0 )
	
	local wifiMat = Material( "datapad/other/ping.png" )
	local ptmr = CurTime() + 1
	local p = LocalPlayer():Ping()
	local c = Color( math.min( 255, p ), math.max( 0, 255 - p ), 0, 255 )
	ping.Paint = function( self, w, h )
		if ptmr < CurTime() then
			local tmpp = LocalPlayer():Ping()
			if not ( p == tmpp ) then
				p = tmpp
				c = Color( math.min( 255, p ), math.max( 0, 255 - p ), 0, 255 )
			end
			
			ptmr = CurTime() + 1
		end
		draw.DrawText( p, "DermaLarge", w*0.7, h*0.2, c, TEXT_ALIGN_CENTER )
		
		draw.NoTexture()
	
		surface.SetMaterial( wifiMat )
		surface.SetDrawColor( color_black )
		surface.DrawTexturedRect( 0, h*0.27, w*0.33, h*0.5 )
		
		return true
	end

	hook.Run( "DatapadPostTaskBar", bar )
end

function datapad:createScreen()
	local hookReturn = hook.Run( "DatapadPreScreenCreate" )
	if hookReturn then return end

	if not isstring( self.shutdownTimer ) then self.shutdownTimer = "DatapadShutdown" .. LocalPlayer():EntIndex() end
	
	local background = vgui.Create( "DFrame" )
	background:SetPos( 0, 0 )
	background:SetSize( ScrW(), ScrH() )
	background:SetTitle( "" )
	background:SetDraggable( false )
	background:MakePopup()
	background:SetPopupStayAtBack( true )
	background:ShowCloseButton( false )
	
	self.OpenApps = {}
	self.screen = background
	
	local background_clr = Color(126, 185, 181)
	background.Paint = function( self, w, h )
		surface.SetDrawColor( background_clr )
		surface.DrawRect( 0, 0, w, h )
	end
	
	background.OnClose = function()
		background:Remove()
	end
	
	local grid = vgui.Create( "DGrid", background )
	grid:SetPos( ScrW()*0.01 , 100 )
	grid:SetCols( 10 )
	grid:SetColWide( ScrW() * 0.099 )
	grid:SetRowHeight( ScrH() * 0.193 )	
	
	hook.Run( "DatapadPostScreenCreate", background )
	
	taskBar( background )
	populateApps( grid )
end

net.Receive( "datapad_open", function()
	datapad:createScreen()
end )

net.Receive( "datapad_get_dev", function()
	datapad.devMode = net.ReadBool()
	
	if not net.ReadBool() then return end
	
	local files, directories = file.Find( "datapad/*", "LUA" )

	for _, dir in ipairs( directories ) do
		files, directories = file.Find( "datapad/" .. dir .. "/*.lua", "LUA" )
		for _, v in ipairs( files ) do
			include( "datapad/" .. dir .. "/" .. v )
		end
	end
end )

hook.Add( "InitPostEntity", "DatapadPlayerLoaded", function()
	net.Start( "datapad_ply_first" )
	net.SendToServer()
end )