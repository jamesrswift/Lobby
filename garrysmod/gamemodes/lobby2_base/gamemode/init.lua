--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include( "sh_util.lua" )
include( "sv_mysql.lua" )
include( "sh_modules.lua" )
include( "sh_usergroups.lua" )
include( "shared.lua" )


AddCSLuaFile( "extensions/utf8.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_util.lua" )
AddCSLuaFile( "sh_modules.lua" )
AddCSLuaFile( "sh_usergroups.lua" )
AddCSLuaFile( "cl_init.lua" )

function GM:Initialize()

	self:Print( "Initializing ..." );
	
	self:InitializeMySQL()

end

function GM:PlayerAuthed( Pl )

	self:LoadPlayerInformation( Pl )

end