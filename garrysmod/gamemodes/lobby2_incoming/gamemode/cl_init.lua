--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Chewgum, 2015
	
-----------------------------------------------------------]]--

include( "shared.lua" )
include( "sh_config.lua" )
--include( "cl_deathnotice.lua" )
include( "cl_hud.lua" )

function GM:GetTeamColor( Entity )

	if Entity:IsPlayer() then
	
		return team.GetColor( Entity:Team() )
		
	end
	
end

function GM:InitPostEntity( )

	self.BaseClass:InitPostEntity( )
	
	self.NormalMusic = self.SoundManager:PlayFile( "sound/incoming/music_loop1.mp3", true, 1, true, 1 )
	self.WinMusic = self.SoundManager:PlayFile( "sound/incoming/music_loop2.mp3", true, 2, false, 0 )

end

net.Receive( "IncomingWin", function( len )

	local Winner = net.ReadEntity( )
	
	GAMEMODE.SoundManager:CrossFade( GAMEMODE.WinMusic, GAMEMODE.NormalMusic, 0.2 )

	timer.Simple( 8, function()
	
		GAMEMODE.SoundManager:CrossFade( GAMEMODE.NormalMusic, GAMEMODE.WinMusic, 0.2 )
	
	end)

end)