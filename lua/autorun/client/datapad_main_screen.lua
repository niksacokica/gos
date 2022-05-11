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

datapad.executeCommand = function( cmd )
	local cAf = string.Explode( " ", cmd )
	cAf[1] = string.lower( cAf[1] )
	
	return istable( datapad.cmds[cAf[1]] ) and tostring( datapad.cmds[cAf[1]]["function"]( cAf ) or "" )
		or "'" .. cAf[1] .. "' is not recognized as a command!\n"
end

local files, directories = file.Find( "datapad/*", "LUA" )

for _, d in ipairs( directories ) do
	if not ( d == "apps" ) and not ( d == "commands" ) then continue end

	files, directories = file.Find( "datapad/" .. d .. "/*.lua", "LUA" )
	for _, v in ipairs( files ) do
		include( "datapad/" .. d .. "/" .. v )
	end
end

local background_clr = Color(126, 185, 181)
local function createScreen()
	local background = vgui.Create( "DFrame" )
	background:SetPos( 0, 0 )
	background:SetSize( ScrW(), ScrH() )
	background:SetTitle( "" )
	background:SetDraggable( false )
	background:SetKeyboardInputEnabled( true )
	background:SetMouseInputEnabled( true )
	background:MakePopup()
	background:SetPopupStayAtBack( true )
	
	background.Paint = function( self, w, h )
		surface.SetDrawColor( background_clr )
		surface.DrawRect( 0, 0, w, h )
	end
	
	background.OnClose = function()
		background:Remove()
	end
	
	populateApps( background )
end

function populateApps( background )
	local w = 0.03
	local h = 0.05
	
	for k, v in pairs( datapad.apps ) do
		local app = vgui.Create( "DButton", background )
		app:SetText( "" )
		app:SetPos( ScrW() * w, ScrH() * h )
		app:SetSize( ScrW() * 0.1, ScrH() * 0.1778 )
		app.DoDoubleClick = function()
			local pnl = v["window"]( background )
			if not IsValid( pnl ) then
				ErrorNoHalt( v["name"] .. " did not return the panel! Please contact the creator " .. v["creator"] .. "!" )
				background:Remove()
				
				return
			end
			
			pnl:SetParent( background )
		end
		
		app.Paint = function( self, w, h )
			surface.SetDrawColor( color_white )
			surface.SetMaterial( Material( v["icon"] ) )
			surface.DrawTexturedRect( 0, 0, w, h )
		end
		
		w = w + 0.03
		if w >= ScrW() then
			w = 0.03
			h = h + 0.05
		end
	end
end

hook.Add( "DatapadTrigger", "DatapadTriggerMain", createScreen )