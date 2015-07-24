--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Notification = GM.Notification or { }
GM.Notification.Types = GM.Notification.Types or { }
GM.Notification.Active = GM.Notification.Active or { }

function GM.Notification:AddType( Identifier, tbl )

	if ( self.Types[ Identifier ] ) then return end
	self.Types[ Identifier ] = tbl

end

function GM.Notification.CreatePanel( Type, Text, Lifetime )

	local GM = GM or gmod.GetGamemode()
	local TypeTable = GM.Notification.Types[ Type ] or GM.Notification.Types[ "Default" ]
	
	local lobby_notification = vgui.Create( "lobby_notification" )
	lobby_notification:SetPos( ScrW(), ScrH() )
	lobby_notification:SetSize( 200, 32 )
	lobby_notification:SetDuration( Lifetime )
	lobby_notification:SetText( Text )
	
	lobby_notification:SetIcon( TypeTable.icon )
	lobby_notification:SetColor( TypeTable.color )
	lobby_notification:SetLighterColor( TypeTable.light )
	lobby_notification:SetDarkerColor( TypeTable.dark )

	table.insert( GM.Notification.Active, lobby_notification )
	
	lobby_notification.OnTimeOver = function( self )
	
		table.RemoveByValue( GM.Notification.Active, self )
		self:Remove()
		
	end
	
end

function GM.Notification.CalculatePosition( index )

	local GM = GM or gmod.GetGamemode( )

	local y = ScrH() - (#GM.Notification.Active * 40 ) + ( index - 1 ) * 40
	local x = ScrW() - GM.Notification.Active[ index ]:GetSize() - 50

	return x, y
	
end

function GM.Notification.Think( )

	local GM = GM or gmod.GetGamemode()
	
	for k, v in pairs( GM.Notification.Active ) do
	
		local x, y = GM.Notification.CalculatePosition( k )
		local curx, cury = v:GetPos()
		
		v:SetPos( Lerp( 5 * FrameTime() * (cury/y), curx, x ) , Lerp( 5 * FrameTime() * (curx/x) , cury, y ) )
		
	end

end

function GM.Notification.NetMessage( len )

	local GM = GM or gmod.GetGamemode( )

	local Type = net.ReadString( )
	local Text = net.ReadString( )
	local Lifetime = net.ReadFloat( )
	
	if ( Type and Text and Lifetime ) then
	
		GM:Notify( Type, Text, Lifetime )
	
	end

end

net.Receive( "lobby_notification", GM.Notification.NetMessage )

function GM:Notify( Type, Text, Lifetime )

	local GM = GM or gmod.GetGamemode()

	if ( not self.Notification.Types[ Type ] ) then Type = "Default" end

	GM.Notification.CreatePanel( Type, Text, Lifetime )

end


GM.Notification:AddType( "Default", {
	icon = Material("vgui/notices/hint"),
	color = Color( 100, 100, 100 ),
	light = Color( 120, 120, 120 ),
	dark = Color( 70, 70, 70 )
} )

GM.Notification:AddType( "Blue", {
	icon = Material("lobby2/notification/justify1.png"),
	color = Color( 45, 80, 111 ),
	light = Color( 76, 109, 138 ),
	dark = Color( 23, 56, 86 )
} )

GM.Notification:AddType( "Red", {
	icon = Material("lobby2/notification/letter x.png"),
	color = Color( 172, 64, 61 ),
	light = Color( 213, 114, 111 ),
	dark = Color( 133, 31, 28 )
} )

GM.Notification:AddType( "Green", {
	icon = Material("vgui/notices/hint"),
	color = Color( 113, 157, 56 ),
	light = Color( 154, 194, 101 ),
	dark = Color( 79, 121, 25 )
} )