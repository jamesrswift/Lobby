--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Alex Swift, ULX, 2015
	
-----------------------------------------------------------]]--

util.AddNetworkString( "lobby2.resize" )

local Module = Module
Module.divider = math.log(1.0/2.0)

Module.Hooks = {
	"PlayerInitialspawn",
	"Tick"
}

function Module:SendOffset( Pl, size )

	net.Start( "lobby2.resize" )
	net.WriteEntity( Pl )
	net.WriteFloat( size or 1 )
	net.Broadcast( )
	
end

function Module:AdjustScale( Pl )

	local eyeheight = Pl:GetInfo("resize_eyeoffset") and tonumber( Pl:GetInfo("resize_eyeoffset") ) or false
	local scale, adjust = 1, true
	local psc = 1.0

	-- Adjust for personal eye height
	if ( eyeheight ) then
		
		local eyescale = eyeheight > 0 and eyeheight or 0
		psc = psc * eyescale;
		
	end
	
	Pl.Progress = Pl.Progress or -1
	
	-- If we are still scaling the player
	if ( Pl.Progress ~= -1 ) then
	
		--if ( not Pl.Progress ) then self:StoreSize( Pl, 1 ) end
		
		adjust = true
		
		Pl.Progress = Pl.Progress + FrameTime()*100; 
		
		-- Check if we have finished scaling the player
		if (Pl.Progress >= Pl.EndProgress) then 
			
			Pl.Scale = Pl.TargetScale
			Pl.Progress = -1
			
		else
		
			if Pl.ExponentialScaling then
				Pl.Scale = Pl.SourceScale * (1/2) ^ ( Pl.Progress * Pl.ScaleSpeed )
			else
				Pl.Scale = Pl.SourceScale + Pl.Progress * Pl.ScaleSpeed
			end
			
		end
		
		self:SendOffset( Pl, Pl.Scale )
		Pl:SetModelScale( Pl.Scale, 0 )
		
	end
	
	
	if ( not Pl.OldPsc or psc ~= Pl.OldPsc ) then adjust=true end
	
	Pl.OldPsc = psc
	scale = Pl.Scale or 1
	
	if adjust then
	
		local vsc=psc*scale
		
		local jumpscale = scale/math.sqrt(psc)
		if ( jumpscale<1 ) then jumpscale=1 end
		
		Pl:SetJumpPower( math.sqrt(jumpscale)* self.Sizing.Default.JumpPower )
		
		-- Step size
		local ss= scale * self.Sizing.Default.StepSize
		if ( ss > self.Sizing.Default.MaxStepSize ) then  ss = self.Sizing.Default.MaxStepSize end
		Pl:SetStepSize( ss )
		
		-- Set view offsets
		Pl:SetViewOffset( vsc * self.Sizing.Default.ViewOffset )
		Pl:SetViewOffsetDucked( vsc * self.Sizing.Default.ViewOffsetDuck )
		Pl:SetNetworkedFloat( "PlViewOffset", vsc )
		
		-- Set hull scale
		local hsc=vsc
		if( hsc > self.Sizing.Default.MaxHullScale ) then hsc = self.Sizing.Default.MaxHullScale end
		
		Pl:SetNetworkedFloat( "PlHullScale", hsc )
		Pl:SetHull( hsc * self.Sizing.Default.StandingHull.Minimum	, hsc * self.Sizing.Default.StandingHull.Maximum )
		Pl:SetHullDuck( hsc * self.Sizing.Default.DuckingHull.Minimum	, hsc * self.Sizing.Default.DuckingHull.Maximum )
		
	end
	
	local ws = math.sqrt( scale ) * self.Sizing.Default.WalkSpeed
	local rs = math.sqrt( scale ) * self.Sizing.Default.RunSpeed
	
	gamemode.Call( "SetPlayerSpeed", Pl, ws, rs)	

end


function Module:Tick( )	
	
	for k, Pl in pairs( player.GetAll( ) ) do
		if Pl:Alive() then
			self:AdjustScale( Pl )
		end
	end
	
end

function Module:StoreSize( Pl, scale)

	local data = Pl:GetData( )
	if ( data ) then
		data.size = scale
	end
	
	Pl:SaveData( )
	
end

function Module:PlayerInitialSpawn( Pl )

	local data = Pl:GetData( )
	if ( data and data.size ) then
	
		SendOffset( Pl, data.size )
		Pl:SetNetworkedFloat( "PlViewOffset", 1 );
		Pl:SetNetworkedFloat( "PlHullScale",1 );
		Pl.Scale = data.size
		Pl.TargetScale = data.size
		Pl.ScaleSpeed = 0
		Pl.EndProgress = 0;
		Pl.Progress = 0
		Pl.ExponentialScaling = true
		
		self:AdjustScale( Pl )
		
	end
	
end

function Module:ScalePlayer( Pl, scale, endprogress, exponential )

	scale = scale > 0 and scale or 0.00001
	
	Pl.Scale = Pl.Scale or scale
	Pl.SourceScale = Pl.Scale
	Pl.TargetScale = scale
	Pl.Progress = 0
	Pl.EndProgress = endprogress
	Pl.ExponentialScaling = exponential
	Pl.ScaleSpeed = exponential and math.log( Pl.TargetScale / Pl.Scale ) / endprogress / self.divider or (pl.TargetScale - pl.Scale) / endprogress

	self:SendOffset( Pl, Pl.SourceScale )
	self:StoreSize( Pl, Pl.TargetScale )
	
end

function Module:EasyScale( Pl, Scale )

	self:ScalePlayer( Pl, Scale, math.exp(1.1002*(10-6)), true )

end
