--[[module( "LobbyCommand", package.seeall )]]--

LobbyCommand= {}
LobbyCommand.Commands = { }

function LobbyCommand.AddCommand( Name , Function )

	if LobbyCommand.Commands[ string.lower(Name) ] then return end

	LobbyCommand.CommandOverride( Name , Function )
	
end

function LobbyCommand.CommandOverride( Name , Function )

	LobbyCommand.Commands[ string.lower(Name) ] = Function

end

function LobbyCommand.Call( Name , ... )

	if LobbyCommand.Commands[ string.lower(Name) ] then
	
		return pcall( LobbyCommand.Commands[ string.lower(Name) ] , ... )
		
	else
	
		ErrorNoHalt( "Sorry, That command does not exist!\n" )
		
	end
	
end

function LobbyCommand.GetAll( )

	return LobbyCommand.Commands
	
end


function LobbyCommand.Remove( Name )

	LobbyCommand.Commands[ string.lower(Name) ] = nil
	
end

concommand.Add( "Lobby" , function( pl , cmd , args )

	if !LobbyCommand.Commands[ string.lower(args[1]) ] then ErrorNoHalt( "Sorry, That command does not exist!\n" ) return end
	
	// transform args
	
	local Name = args[1]
	local Arguments = { }
	for i=2,#args do Arguments[ i-1] = args[i] end
	
	LobbyCommand.Call( string.lower(Name) , pl, cmd , Arguments ) -- CMD will always be Lobby, I've added it for retrocompatabilty though
	
end)