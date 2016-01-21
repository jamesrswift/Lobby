--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Admin = GM.Admin or { }
GM.Admin.Commands = GM.Admin.Commands or { }

function GM.Admin:GetCommands( )

	return self.Commands
	
end

function GM.Admin:RegisterCommand( name, callback, args )

	local GM = GM or gmod.GetGamemode( )
	
	self:GetCommands( )[name] = args

	concommand.Add( name, function( Pl, cmd, args )
	
		if ( Pl:IsAdmin( ) ) then

			GM:Log( "admin", "%s ran the admin command %s", Pl:Nick(), name)
			callback( Pl, unpack( args ) )
		
		end
	
	end)

end

include( "admin/undercover.lua" )
