--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.SoundManager = GM.SoundManager or { }
GM.SoundManager.Chanels = GM.SoundManager.Chanels or { }
GM.SoundManager.CrossFades = GM.SoundManager.CrossFades or { }

function GM.SoundManager:PlayFile( path, looping, chanel, shouldfade, fade, cb )

	local GM = GM or gmod.GetGamemode( )
	chanel = chanel or #self.Chanels + 1
	
	shouldfade = shouldfade and shouldfade or true
	fade = fade and fade or 2
	
	sound.PlayFile( path, "noplay noblock", function( IGModAudioChannel, errorID, errorName ) 
	
		if ( errorID ) then
		
			GM:Print( "There was an error while trying to play sound '%s', ERROR #%i : %s", path, errorID, errorName )
			return 
			
		end
		
		if ( self.Chanels[ chanel ] and IsValid( self.Chanels[ chanel ] ) ) then
		
			if ( self.Chanels[ chanel ]:GetState() == GMOD_CHANNEL_STOPPED or not IsValid( self.Chanels[ chanel ] ) ) then
			
				self.Chanels[ chanel ] = nil
				self.Chanels[ chanel ] = IGModAudioChannel
				
				if ( shouldfade ) then
					self:CrossFade( chanel, nil, fade )
				end
				
			else
			
				self.Chanels[ chanel + 1 ], self.Chanels[ chanel ] = self.Chanels[ chanel ], IGModAudioChannel
				
				-- Mark for cross fade
				if ( shouldfade ) then
					self:CrossFade( chanel, chanel + 1, fade )
				end
			
			
			end
			
		else
		
			self.Chanels[ chanel ] = IGModAudioChannel
			
			if ( shouldfade ) then
				self:CrossFade( chanel, nil, fade )
			end
			
		end
		
		if ( cb ) then
		
			cb( )
		
		end
		
		self.Chanels[ chanel ]:SetVolume( 0 )
		self.Chanels[ chanel ]:Play( )
		self.Chanels[ chanel ]:EnableLooping( looping and looping or true )
		
	
	end)
	
	return chanel

end

function GM.SoundManager:CrossFade( entering_chanel, exiting_chanel, duration )
	
	if ( duration == 0 ) then
	
		self.Chanels[ entering_chanel ]:SetVolume( 1 )
		
		if ( self.Chanels[ exiting_chanel ] ) then
			self.Chanels[ exiting_chanel ]:SetVolume( 0 )
		end
		
		return
		
	end

	table.insert( self.CrossFades, {
		c_start = entering_chanel,
		c_end = exiting_chanel,
		init = CurTime( ),
		duration = duration
	})

end

function GM.SoundManager:ManageCrossFades( )

	for k, info in pairs( self.CrossFades ) do
	
		if ( not IsValid( self.Chanels[ info.c_start ] ) )  then
		
			table.remove( self.CrossFades, k )
			
		else
			
			self.Chanels[ info.c_start ]:SetVolume( Lerp( ( CurTime( ) - (info.init + info.duration ) ) / info.duration , 0, 1 ) )
			
			if ( IsValid( self.Chanels[ info.c_end ] ) ) then
				self.Chanels[ info.c_end ]:SetVolume( Lerp( ( CurTime( ) - (info.init + info.duration ) ) / info.duration , 1, 0 ) )
			end
			
			
			if ( self.Chanels[ info.c_start ]:GetVolume() == 1 ) then
			
				table.remove( self.CrossFades, k )
			
			end
			
		end
	
	end

end

