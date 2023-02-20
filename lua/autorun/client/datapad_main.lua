datapad = istable( datapad ) and datapad or {}

function datapad:AddApp( app )
	self.apps = istable( self.apps ) and self.apps or {}
	
	local hookReturn = hook.Run( "DatapadAddApp", app["name"] )
	
	--if istable( self.apps[app["name"]] ) then
		--ErrorNoHalt( "App with the name  '" .. app["name"] .. "'  already exists!" )
	--elseif not hookReturn then
		self.apps[string.lower( app["name"] )] = app
	--end
end

local files, directories = file.Find( "datapad/*", "LUA" )

for _, dir in ipairs( directories ) do
	files, directories = file.Find( "datapad/" .. dir .. "/*.lua", "LUA" )
	for _, v in ipairs( files ) do
		include( "datapad/" .. dir .. "/" .. v )
	end
end

if not file.Exists( "datapad/personal_files/appdata", "DATA" ) or not file.Exists( "datapad/personal_files/desktop", "DATA" ) or not file.Exists( "datapad/personal_files/documents", "DATA" ) then
	file.CreateDir( "datapad/personal_files/appdata" )
	file.CreateDir( "datapad/personal_files/desktop" )
	file.CreateDir( "datapad/personal_files/documents" )
end

function datapad:StartApp( v )
	local hookReturn = hook.Run( "DatapadPreAppStart", v )
	if hookReturn then return end

	local window = vgui.Create( "DFrame" )
	window:Center()
	window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
	window:SetParent( self.screen )
	window:MakePopup()
	
	function handleWindowClose()
		for key, val in ipairs( self.screen.OpenApps ) do
			if val[2] == v["name"] and val[1] == window then
				table.remove( self.screen.OpenApps, key )
				
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
	
	table.insert( self.screen.OpenApps, { window, v["name"] } )
	v["window"]( window )
	
	hook.Run( "DatapadPostAppStart", v )
	
	return window
end

local function populateApps( grid )
	local hookReturn = hook.Run( "DatapadPreAppPopulate", datapad.apps )
	if hookReturn then return end

	for k, v in SortedPairs( datapad.apps ) do
		local app = vgui.Create( "DButton" )
		app:SetText( "" )
		app:SetSize( grid:GetColWide() - 50, grid:GetRowHeight() - 50 )
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
	
	background.OpenApps = {}
	self.screen = background
	
	background.Paint = function( self, w, h )
		surface.SetDrawColor( background_clr )
		surface.DrawRect( 0, 0, w, h )
	end
	
	background.OnClose = function()
		background:Remove()
	end
	
	local grid = vgui.Create( "DGrid", background )
	grid:SetPos( 50, 50 )
	grid:SetCols( 10 )
	grid:SetColWide( ( ScrW() / 10 ) - 5 )
	grid:SetRowHeight( ScrW() / 9.1 - 5 )	
	
	hook.Run( "DatapadPostScreenCreate" )
	
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

net.Receive( "datapad_open", function(len)
	datapad:createScreen()
end )