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
	if hookReturn or #self.OpenApps >= 66 then return end

	local window = vgui.Create( "DFrame" )
	window:Center()
	window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
	window:SetParent( self.screen )
	window:MakePopup()
	
	local ind = #self.OpenApps
	local function handleWindowClose()
		if window.OnDelete then
			window:OnDelete()
		end
		
		for key, val in ipairs( self.OpenApps ) do
			if val[2] == v["name"] and val[1] == window then
				table.remove( self.OpenApps, key )
				
				hook.Run( "DatapadAppClosed" )
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
	
	hook.Run( "DatapadPostAppStart", v )
end

local function populateApps( grid )
	local hookReturn = hook.Run( "DatapadPreAppPopulate", datapad.apps )
	if hookReturn then return end

	for k, v in SortedPairs( datapad.apps ) do
		local app = vgui.Create( "DButton" )
		app:SetText( "" )
		app:SetSize( grid:GetColWide()*0.8, grid:GetRowHeight()*0.8 )
		app.DoDoubleClick = function()
			datapad:StartApp( v )
		end
		
		local app_icon = Material( v["icon"] )
		app.Paint = function( self, w, h )
			surface.SetDrawColor( color_white )
			surface.SetMaterial( app_icon )
			surface.DrawTexturedRect( 0, 0, w, h )
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
	bar:SetSize( ScrW(), 33 )
	bar:SetPaintBackground( true )
	bar:MakePopup()
	bar:SetPopupStayAtBack( true )
	
	local icon = vgui.Create( "DButton", bar )
	icon:SetText( "" )
	icon:SetPos( 3, 3 )
	icon:SetSize( 27, 27 )
	icon.DoClick = function()
		background:Remove()
	end
	
	local iconMat = Material( "icon16/stop.png" )
	icon.Paint = function( self, w, h )
		draw.NoTexture()
	
		surface.SetMaterial( iconMat )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
	
	local openApps = vgui.Create( "DGrid", bar )
	openApps:SetPos( 40, 3 )
	datapad.TaskBar = openApps
	
	local function fillTaskBar()
		if not IsValid( datapad.TaskBar ) then return end
		datapad.TaskBar:Clear()
		datapad.TaskBar.Items = {}
		
		local numMath = ( 1 / #datapad.OpenApps ) * ScrW()
		datapad.TaskBar:SetCols( #datapad.OpenApps )
		datapad.TaskBar:SetColWide( math.min( numMath * 0.937, ScrW() * 0.075 ) )
	
		for k, v in ipairs( datapad.OpenApps ) do		
			local openApp = vgui.Create( "DButton" )
			openApp:SetText( v[2] )
			openApp:SetColor( color_black )
			openApp:SetSize( math.min( numMath * 0.85, ScrW() * 0.07 ), 27 )
			
			local out_clr = Color( 100, 100, 100 )
			local in_clr = Color( 200, 200, 200 )
			local in_clr_sel = Color( 150, 150, 150 )
			local ico = Material( v[3] )
			openApp.Paint = function( self, w, h )
				surface.SetDrawColor( out_clr:Unpack() )
				surface.DrawOutlinedRect( 0, 0, w, h, 5 )
				
				surface.SetDrawColor( ( v[1]:HasFocus() and in_clr_sel or in_clr ):Unpack() )
				surface.DrawRect( 1, 1, w - 2, h - 2 )
				
				draw.NoTexture()
	
				surface.SetMaterial( ico )
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect( 0, 0, w, h )
			end
			
			openApp.DoClick = function()
				v[1]:MoveToFront()
			end
			
			datapad.TaskBar:AddItem( openApp )
		end
	end
	
	hook.Add( "DatapadPostAppStart", "DatapadAddAppToTaskBar", fillTaskBar )
	
	hook.Add( "DatapadAppClosed", "DatapadRemoveAppFromTaskBar", fillTaskBar )
	
	local dateTime = vgui.Create( "DLabel", bar )
	dateTime:SetText( "" )
	dateTime:SetPos( ScrW() - 66, 3 )
	dateTime:SetSize( 55, 30 )
	
	dateTime.Paint = function( self, w, h )
		draw.DrawText( os.date( "%H:%M\n%d.%m.%Y" ), "DermaDefault", w*0.5, 0, color_black, TEXT_ALIGN_CENTER )
		
		return true
	end
	
	local ping = vgui.Create( "DLabel", bar )
	ping:SetText( "" )
	ping:SetPos( ScrW() - 125, 3 )
	ping:SetSize( 50, 28 )
	
	local wifiMat = Material( "icon16/bullet_feed.png" )
	ping.Paint = function( self, w, h )
		local p = LocalPlayer():Ping()
		local c = Color( math.min( 255, p ), math.max( 0, 255 - p ), 0, 255 )
		draw.DrawText( p, "GModNotify", w*0.7, h*0.1, c, TEXT_ALIGN_CENTER )
		
		draw.NoTexture()
	
		surface.SetMaterial( wifiMat )
		surface.SetDrawColor( c:Unpack() )
		surface.DrawTexturedRect( 0, 0, w*0.6, h )
		return true
	end

	hook.Run( "DatapadPostTaskBar" )
end

local background_clr = Color(126, 185, 181)
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
	
	hook.Run( "DatapadPostScreenCreate" )
	
	taskBar( background )
	populateApps( grid )
end

function surface.DrawCircleFilled( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
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