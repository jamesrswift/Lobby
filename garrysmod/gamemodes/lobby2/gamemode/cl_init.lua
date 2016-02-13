--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

include( "shared.lua" )
include( "cl_adverts.lua" )

function GM:Think( )

	self.BaseClass:Think( )
	self.Adverts.Think( )

end

function GM:LobbyScoreboard( Pl )

	return {
	
		{
			Name = "Money",
			
			Element = "DLabel",
			Width = 50,
			Font = "LobbyChat",
			TextColor = Color( 93, 93, 93 ),
			ContentAlignment = 5,
			
			Update = function( self, Pl )
			
				self:SetText( Pl:GetMoney( ) )
			
			end
		}
	
	}


end