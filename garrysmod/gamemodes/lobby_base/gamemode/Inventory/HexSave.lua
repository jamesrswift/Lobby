// Encoder Decoder

function LobbyInventory.Encode( Inv )

	local data = Hex()

	for k,v in ipairs( Inv ) do
	
		data:WriteString( v[2] , 0x00 );
		data:WriteInt( v[1] , 4 );
		data:WriteInt( k , 4 );
		
	end
	
	return data:GetData()


end

function LobbyInventory.Decode( String )

	local Inv = { }
	local data = Hex( String );
	while( data:CanGet( 10 ) ) do
		
		local Slot = data:GetInt( 4 );
		local Item = data:GetInt( 4 );
		local Extra = data:GetString( 0x00 );
		
		Inv[ Slot ] = { Item , Extra }
		
	end
	
	return Inv

end