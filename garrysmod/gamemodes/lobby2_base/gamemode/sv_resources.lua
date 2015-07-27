--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.ResourceDirectory = "lobby2_base/content/"
GM.BadExtensions = {
	
}

function GM:SendResources( Directory, basedir )

	basedir = basedir or self.ResourceDirectory
	
	local files, folders = file.Find( basedir .. Directory .. "/*", "LUA" )
	
	for k, v in pairs( files ) do
		if ( self:CheckResourceExtension( v ) ) then
			resource.AddFile( basedir .. Directory .. "/" .. v )
		end
	end
	
	for k, folder in pairs( folders ) do
		self:SendResources( Directory .. "/" .. folder, basedir )
	end
	
end
	
function GM:CheckResourceExtension( filename )

	return ( not table.HasValue( self.BadExtensions, string.GetExtensionFromFilename( filename ) ) )

end