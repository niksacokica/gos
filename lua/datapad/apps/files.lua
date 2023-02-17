function datapad:GetDesktopFiles()
	for i,v in ipairs( file.Find( "datapad/personal_files/desktop/*", "DATA" ) ) do
		datapad:AddApp({
			["name"] = v,
			--dynamic icons soon
			["icon"] = "datapad/files/doc_".. string.GetExtensionFromFilename( v ) ..".png",
			["creator"] = LocalPlayer():GetName(),
			["window"] = function(window)
				Notepad( window, "datapad/personal_files/desktop/".. v )
			end
		})
	end
end