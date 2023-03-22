hook.Add( "DatapadPreScreenCreate", "DatapadEmailsGet", function()
	net.Start( "datapad_email_get" )
		net.WriteBool( true )
	net.SendToServer()
end )

net.Receive( "datapad_email_all", function()
	datapad.Emails = net.ReadTable()
end )

net.Receive( "datapad_email_new", function()
end )