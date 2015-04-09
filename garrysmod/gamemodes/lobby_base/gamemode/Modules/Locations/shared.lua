
GM.Locations = {

	{ "The Plaza" , Vector( -1024, -2752, 320 ) , Vector( -192, -1344, -64 ) },
	{ "The Tower" , Vector( -832 , -1120, 448 ) , Vector( -64 , -256 , 1280) }
}

function GM:AddLocation( name , tab )
	self.Locations[ name ] = tab
end

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:GetLocation()
	return self:GetNWString( "Location" )
end
