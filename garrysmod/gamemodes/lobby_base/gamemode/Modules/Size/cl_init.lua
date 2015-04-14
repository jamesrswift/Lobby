
include( "shared.lua" )

local function Tick( um )
	
	local v = um:ReadEntity()
	local pscale = um:ReadFloat()
	if not pscale then
		pscale = 1
	end;
	local ScaleVector = pscale * Vector(1,1,1)
	v:SetModelScale( pscale, 0 )
	v:SetRenderBounds( pscale * Sizing.Default.StandingHull.Minimum, pscale * Sizing.Default.StandingHull.Maximum )			

	--get the view offset (shared function but executing it on client side fixes some screen shaking issues)
	local vsc = v:GetNetworkedFloat("PlViewOffset")
	if not vsc then
		vsc = 1
	end;
	v:SetViewOffset( 	vsc*Sizing.Default.ViewOffset 		)
	v:SetViewOffsetDucked( 	vsc*Sizing.Default.ViewOffsetDuck 	)

	--get the player hull (again shared function but executing it on client side fixes some screen shaking issues)
	local hsc = v:GetNetworkedFloat("PlHullScale")
	if not hsc then
		hsc = 1
	end;
	v:SetHull( 	hsc*Sizing.Default.StandingHull.Minimum	, hsc*Sizing.Default.StandingHull.Maximum 	)
	v:SetHullDuck( 	hsc*Sizing.Default.DuckingHull.Minimum	, hsc*Sizing.Default.DuckingHull.Maximum 	)					
end

usermessage.Hook( "size", Tick );