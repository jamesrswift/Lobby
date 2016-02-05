--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

local buffer_meta = { }

function Buffer( data )

	local buf = { }
	buf.data = data or ""
	buf.pos = 0
	
	setmetatable( buf, { __index = buffer_meta })
	return buf

end

function buffer_meta:SetData( data )

	self.data = data
	
end

function buffer_meta:GetData( )

	return self.data or ""
	
end

function buffer_meta:SetPos( pos )

	self.pos = pos
	
end

function buffer_meta:GetPos( )

	return self.pos
	
end

function buffer_meta:AdvancePos( num )

	self:SetPos( self:GetPos() + num )
	
end


function buffer_meta:Peek( num )

	local ret = string.sub( self.data , self:GetPos(), self:GetPos() + num )
	self:AdvancePos( num )
	
	return ret
	
end

function buffer_meta:Push( data, size )
	
	self:SetData( string.sub( self.data, 1 , self.pos) .. data .. string.sub( self.data , self.pos + 1 ) )
	self:AdvancePos( string.len( data )  )

end

function buffer_meta:ReadInteger( )

	local bytes = self:Peek(4)
	return bit.rol( bit.bor( bit.lshift( 	string.byte( bytes, 1 ), 24 ),
					bit.bor( bit.lshift( 	string.byte( bytes, 2 ), 16 ),
					bit.bor( bit.lshift( 	string.byte( bytes, 3 ), 8 ),
											string.byte( bytes, 4 )
		))), 1 )
	
end

function buffer_meta:WriteInteger( int )

	int = bit.ror( int, 1 )

	self:Push(
		string.char(
			bit.rshift( bit.band( int , 0xFF000000 ), 24 ),
			bit.rshift( bit.band( int , 0x00FF0000 ), 16 ),
			bit.rshift( bit.band( int , 0x0000FF00 ), 8 ),
						bit.band( int , 0x000000FF )
		)
	)
	
end


function buffer_meta:ReadStringNT( )

	local str = ""
	local peek = self:Peek( 1 )
	
	while ( peek ~= "\000" ) do
		str = str .. peek
		peek = self:Peek( 1 )
	end
	
	return str

end

function buffer_meta:WriteStringNT( str )

	str = string.gsub( str, "\000", "" )
	self:Push( str .. "\000")

end

function buffer_meta:ReadString( num )
	
	return self:Peek( num )

end

function buffer_meta:WriteString( str )

	self:Push( str )

end

function buffer_meta:ToPacket( )

	local packet = BromPacket()
	packet:WriteLine( self:GetData() )
	
	return packet

end
