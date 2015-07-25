--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Chat = GM.Chat or {}
GM.Chat.Smilies = GM.Chat.Smilies or {}

function GM.Chat:AddSmiley( tag, mat )
	
	if ( not self.Smilies[ string.lower( tag ) ] ) then
	
		self.Smilies[ string.lower( tag ) ] = mat
		return true
	
	end
	
	return false
	
end

function GM.Chat:GetSmiley( tag )

	return self:GetSmilies()[ string.lower( tag ) ] or false
	
end

function GM.Chat:GetSmilies( )

	return self.Smilies
	
end

function GM.Chat:ParseString( Pl, Str )

	local buffer = {}
	local start, tag, nd = string.match( Str, "()(%b::)()" )
	
	while ( start and tag and nd ) do
	
		table.insert( buffer, {Type = "Text", Data = string.sub( Str, 0, start-1 )} )
		
		local smiley = self:GetSmiley( string.lower( tag ) )
		if ( smiley and hook.Run( "CanPlayerUseSmiley", Pl, tag ) ) then
			table.insert( buffer, {Type = "Image", Data = smiley} )
		else
			table.insert( buffer, {Type = "Text", Data = tag} )
		end
		
		Str = string.sub( Str, nd )
		start, tag, nd = string.match( Str, "()(%b::)()" )

	end
	
	if ( string.len( Str ) > 0 ) then
		table.insert( buffer, {Type = "Text", Data = Str} )
	end
	
	return buffer

end


function GM:CanPlayerUseSmiley( Pl, tag )

	return true
	
end

GM.Chat:AddSmiley( ":smile:", Material( "icon16/emoticon_smile.png" ) )
GM.Chat:AddSmiley( ":sad:", Material( "icon16/emoticon_unhappy.png" ) )
GM.Chat:AddSmiley( ":3:", Material( "icon16/emoticon_waii.png" ) )
GM.Chat:AddSmiley( ":p:", Material( "icon16/emoticon_tongue.png" ) )

GM.Chat:AddSmiley( ":dumb:", Material( "icon16/box.png" ) )
GM.Chat:AddSmiley( ":winner:", Material( "icon16/award_star_gold_1.png" ) )
GM.Chat:AddSmiley( ":late:", Material( "icon16/clock.png" ) )
GM.Chat:AddSmiley( ":zing:", Material( "icon16/lightning.png" ) )
GM.Chat:AddSmiley( ":agree:", Material( "icon16/tick.png" ) )
GM.Chat:AddSmiley( ":disagree:", Material( "icon16/cross.png" ) )
GM.Chat:AddSmiley( ":informational:", Material( "icon16/information.png" ) )
GM.Chat:AddSmiley( ":friendly:", Material( "icon16/heart.png" ) )
GM.Chat:AddSmiley( ":tool:", Material( "icon16/wrench.png" ) )
GM.Chat:AddSmiley( ":optimistic:", Material( "icon16/rainbow.png" ) )
