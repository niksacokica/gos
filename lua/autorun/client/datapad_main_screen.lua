datapad = istable( datapad ) and datapad or {}

datapad.addApp = function( app )
	datapad.apps = istable( datapad.apps ) and datapad.apps or {}
	
	--if istable( datapad.apps[app["name"]] ) then
		--ErrorNoHalt( "App with the name  '" .. app["name"] .. "'  already exists!" )
	--else
		datapad.apps[app["name"]] = app
	--end
end

datapad.addCommand = function( cmd )
	datapad.cmds = istable( datapad.cmds ) and datapad.cmds or {}
	
	local cl = string.lower( cmd["cmd"] )
	
	--if istable( datapad.cmds[cl] ) then
		--ErrorNoHalt( "Command with the name '" .. cl .. "' already exists!" )
	--elseif #cl > 14 then
		--ErrorNoHalt( "Command name '" .. cl .. "' is too long, max length is 14 characters!" )
	--else
		datapad.cmds[cl] = cmd
	--end
end

datapad.executeCommand = function( cmd, window )
	local cAf = string.Explode( " ", cmd )
	for i=#cAf, 1, -1 do
		if #cAf[i] == 0 then
			table.remove( cAf, i )
		end
	end
	cAf[1] = string.lower( cAf[1] )
	
	if istable( datapad.cmds[cAf[1]] ) then return datapad.cmds[cAf[1]]["function"]( cAf, window ) end
	
	return "'" .. cAf[1] .. "' is not recognized as a command!\n"
end

local files, directories = file.Find( "datapad/*", "LUA" )

for _, d in ipairs( directories ) do
	if not ( d == "apps" ) and not ( d == "commands" ) then continue end

	files, directories = file.Find( "datapad/" .. d .. "/*.lua", "LUA" )
	for _, v in ipairs( files ) do
		include( "datapad/" .. d .. "/" .. v )
	end
end

datapad.startApp = function( v )
	local window = vgui.Create( "DFrame" )
	window:Center()
	window:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
	window:SetParent( datapad.screen )
	window:MakePopup()
	
	function handleWindowClose()
		for key, val in ipairs( datapad.screen.OpenApps ) do
			if val[2] == v["name"] and val[1] == window then
				table.remove( datapad.screen.OpenApps, key )
				
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
	
	table.insert( datapad.screen.OpenApps, { window, v["name"] } )
	v["window"]( window )
	
	return window
end

local function populateApps( grid )	
	for k, v in SortedPairs( datapad.apps ) do
		local app = vgui.Create( "DButton" )
		app:SetText( "" )
		app:SetSize( grid:GetColWide() - 50, grid:GetRowHeight() - 50 )
		app.DoDoubleClick = function()
			datapad.startApp( v )
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
end

local background_clr = Color(126, 185, 181)
local function createScreen()
	if not isstring( datapad.shutdownTimer ) then datapad.shutdownTimer = "DatapadShutdown" .. LocalPlayer():EntIndex() end
	
	local background = vgui.Create( "DFrame" )
	background:SetPos( 0, 0 )
	background:SetSize( ScrW(), ScrH() )
	background:SetTitle( "" )
	background:SetDraggable( false )
	background:MakePopup()
	background:SetPopupStayAtBack( true )
	
	background.OpenApps = {}
	datapad.screen = background
	
	--local datapad_screen_effect = Material( "niksacokica/datapad/datapad_screen_effect" )
	background.Paint = function( self, w, h )
		surface.SetDrawColor( background_clr )
		surface.DrawRect( 0, 0, w, h )
		
		--surface.SetDrawColor( color_white )
		--surface.SetMaterial( datapad_screen_effect )
		--surface.DrawTexturedRect( 0, 0, w, h )
	end
	
	background.OnClose = function()
		background:Remove()
	end
	
	local grid = vgui.Create( "DGrid", background )
	grid:SetPos( 50, 50 )
	grid:SetCols( 10 )
	grid:SetColWide( ( ScrW() / 10 ) - 5 )
	grid:SetRowHeight( ScrW() / 9.1 - 5 )	
	
	populateApps( grid )
end

hook.Add( "DatapadTrigger", "DatapadTriggerMain", createScreen )

local tmr = CurTime()
matproxy.Add({
    name = "DatapadScreen", 
    init = function( self, mat, values )
    end,
    bind = function( self, mat, ent )
		if mat:GetName() == "niksacokica/datapad/datapad_screen_effect" and tmr < CurTime() then
			tmr = CurTime() + 0.3
			
			local matrix = mat:GetMatrix( "$basetexturetransform" )
			matrix:Translate( Vector( 0, math.random( -1000, 1000 ), 0 ) )
			
			mat:SetMatrix( "$basetexturetransform", matrix )
		end
	end 
})