hook.Add( "gOSPreScreenCreate", "gOSEmailsGet", function()
	net.Start( "gos_email_get" )
		net.WriteBool( true )
	net.SendToServer()
end )

net.Receive( "gos_email_all", function()
	gos.Emails = net.ReadTable()
end )

net.Receive( "gos_email_new", function()
	local eType = net.ReadString()
	local email = net.ReadTable()
	table.insert( gos.Emails[eType], net.ReadTable() )
	
	hook.Run( "gOSEmailNewEmail", eType, email )
end )