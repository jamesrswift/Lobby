
-- Copyright (c) 2012 , James Swift
-- This script is under this license : https://sites.google.com/site/jamesaddons/home/terms-of-Service

// Stuff

local floor,insert = math.floor, table.insert
local function basen(n,b)

	n = floor(n)
	if not b or b == 10 then return tostring(n) end
	
	local digits = "0123456789ABCDEF"
	local t = {}
	
	repeat
		local d = (n % b) + 1
		n = floor(n / b)
		insert(t, 1, digits:sub(d,d))
	until n == 0
	
	return table.concat(t,"")
	
end


// The hex

local HexTable = {

	Data = "",
	
	SetData = function( self , NewData ) self.Data = NewData end,
	Len = function( self ) return #self.Data end,
	CanGet = function( self, Length ) return ( self:Len( ) > Length ) end,
	GetData = function( self ) return self.Data end,
	WriteRaw = function( self , Value ) self.Data = Value .. self.Data end,
	
	GetPacket = function( self )
		local String = "";
		while( self:CanGet( 2 ) )do
			String = String .. string.char( self:GetInt( 2 ) )
		end
		return String
	end,
	
	GetPacketSize = function( self )
		return self:Len( ) / 2
	end,
	
	// Integers
	
	GetInt = function( self , Length )
		if ( !self:CanGet( Length ) ) then return false end
		local String = string.sub( self:GetData( ) , 0 , Length );
		self.Data = string.gsub( self.Data , String , "" );
		return tonumber( String, 16 )
	end,
	
	WriteInt = function( self, Int , Length )
		local i = basen( Int , 16 )
		local ToAdd = Length - #i;
		if ( ToAdd > 0 ) then i = string.rep( "0" , ToAdd ) .. i end
		self:WriteRaw( i );
	end,
	
	// Stream of Hexadecimal chars
	
	GetStream = function( self, Length )
		if ( !self:CanGet( Length ) ) then return false end
		local String = string.sub( self:GetData( ) , 0 , Length );
		self.Data = string.gsub( self.Data , String , "" );
		return String
	end,
	
	WriteStream = function( self , Table )
		for i=#Table,1,-1 do
			self:WriteRaw( Table[i] , 2 )
		end
		return ( #Table * 2 )
	end,

	
	// Stream with no length
	
	GetStreamNoLen = function( self, Termination )
		Termination = Termination or 0x00;
		local Save = ""
		while( self:CanGet( 2 ) ) do
			local MyInt = self:GetInt( 2 );
			if ( MyInt != Termination ) then
				break
			else
				Save = Save .. MyInt
			end
		end
		return  Save
	end,
	
	WriteStreamNoLen = function( self, Table, Termination )
		Termination = Termination or 0x00;
		local Length = self:WriteStream( Table )
		self:WriteInt( Termination, 2 );
		return ( Length + 2 )
	end,
	
	// String
	
	GetString = function( self, Termination )
		Termination = Termination or 0x00;
		local Save = ""
		while( self:CanGet( 2 ) ) do
			local Int = self:GetInt( 2 )
			if ( Int == Termination ) then break end
			Save = Save .. string.char( Int )
		end
		return Save
	end,
	
	WriteString = function( self, String, Termination )
		Termination = Termination or 0;
		self:WriteInt( Termination, 0, 2 )
		for k,v in pairs( string.ToTable( string.reverse( String ) ) ) do
			self:WriteInt( string.byte( v ) , 2 );
		end
		return self
	end
}


function Hex( Data )

	local t = table.Copy( HexTable );
	t.Data = Data or ""
	
	return t
	
end
