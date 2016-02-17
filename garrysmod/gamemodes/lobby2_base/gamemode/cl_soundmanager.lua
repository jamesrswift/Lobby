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
GM.SoundManager.Channels = GM.SoundManager.Channels or { }
GM.SoundManager.CrossFades = GM.SoundManager.CrossFades or { }

function GM.SoundManager:PlayFile( path, looping, channel, shouldfade, fade, cb )

	local GM = GM or gmod.GetGamemode( )
	channel = channel or #self.Channels + 1
	
	shouldfade = shouldfade and shouldfade or true
	fade = fade and fade or 2
	
	-- Mark channel as used but don't screw up other stuff
	self.Channels[ channel ] = NULL
	
	sound.PlayFile( path, "noplay noblock", function( IGModAudioChannel, errorID, errorName ) 
	
		if ( errorID ) then
		
			GM:Print( "There was an error while trying to play sound '%s', ERROR #%i : %s", path, errorID, errorName )
			return 
			
		end
		
		if ( self.Channels[ channel ] and IsValid( self.Channels[ channel ] ) ) then
		
			if ( self.Channels[ channel ]:GetState() == GMOD_CHANNEL_STOPPED or not IsValid( self.Channels[ channel ] ) ) then
			
				self.Channels[ channel ] = nil
				self.Channels[ channel ] = IGModAudioChannel
				
				if ( shouldfade ) then
					self:CrossFade( channel, nil, fade )
				end
				
			else
			
				self.Channels[ channel + 1 ], self.Channels[ channel ] = self.Channels[ channel ], IGModAudioChannel
				
				-- Mark for cross fade
				if ( shouldfade ) then
					self:CrossFade( channel, channel + 1, fade )
				end
			
			
			end
			
		else
		
			self.Channels[ channel ] = IGModAudioChannel
			
			if ( shouldfade ) then
				self:CrossFade( channel, nil, fade )
			end
			
		end
		
		if ( cb ) then
		
			cb( )
		
		end
		
		self.Channels[ channel ]:SetVolume( 0 )
		self.Channels[ channel ]:Play( )
		self.Channels[ channel ]:EnableLooping( looping and looping or true )
		
	
	end)
	
	return channel

end

function GM.SoundManager:CrossFade( entering_channel, exiting_channel, duration )
	
	if ( duration == 0 ) then
	
		if ( self.Channels[ entering_channel ] ) then
			self.Channels[ entering_channel ]:SetVolume( 1 )
		end
		
		if ( self.Channels[ exiting_channel ] ) then
			self.Channels[ exiting_channel ]:SetVolume( 0 )
		end
		
		return
		
	end

	table.insert( self.CrossFades, {
		c_start = entering_channel,
		c_end = exiting_channel,
		init = CurTime( ),
		duration = duration
	})

end

function GM.SoundManager:ManageCrossFades( )

	for k, info in pairs( self.CrossFades ) do
	
		if ( not IsValid( self.Channels[ info.c_start ] ) )  then
		
			table.remove( self.CrossFades, k )
			
		else
			
			if ( IsValid( self.Channels[ info.c_start ] ) ) then
				self.Channels[ info.c_start ]:SetVolume( Lerp( ( CurTime( ) - (info.init + info.duration ) ) / info.duration , 0, 1 ) )
				
				if ( self.Channels[ info.c_start ]:GetVolume() == 1 ) then
				
					if ( IsValid( self.Channels[ info.c_end ]  ) ) then
						self.Channels[ info.c_end ]:SetVolume( 0 )
					end
			
					table.remove( self.CrossFades, k )
			
				end
				
			end
			
			if ( IsValid( self.Channels[ info.c_end ] ) ) then
				self.Channels[ info.c_end ]:SetVolume( Lerp( ( CurTime( ) - (info.init + info.duration ) ) / info.duration , 1, 0 ) )
				
				if ( self.Channels[ info.c_end ]:GetVolume() == 0 ) then
				
					if ( IsValid( self.Channels[ info.c_start ]  ) ) then
						self.Channels[ info.c_start ]:SetVolume( 1 )
					end
			
					table.remove( self.CrossFades, k )
			
				end
				
			end
			
		end
	
	end

end

