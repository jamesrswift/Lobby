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
	
	if ( not self.Smilies[ tag ] ) then
	
		self.Smilies[ tag ] = mat
		return true
	
	end
	
	return false
	
end

function GM.Chat:GetSmiley( tag )

	return self:GetSmilies()[ tag ] or false
	
end

function GM.Chat:GetSmilies( )

	return self.Smilies
	
end

function GM.Chat:ParseString( Pl, Str )

	local buffer = {}
	local start, tag, nd = string.match( Str, "()(%b::)()" )
	
	while ( start and tag and nd ) do
	
		table.insert( buffer, {Type = "Text", Data = string.sub( Str, 0, start-1 )} )
		
		local smiley = self:GetSmiley( tag )
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
