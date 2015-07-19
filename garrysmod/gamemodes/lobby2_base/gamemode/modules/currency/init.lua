--[[-----------------------------------------------------------

	¦¦+      ¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦+   ¦¦+    ¦¦¦¦¦¦+ 
	¦¦¦     ¦¦+---¦¦+¦¦+--¦¦+¦¦+--¦¦++¦¦+ ¦¦++    +----¦¦+
	¦¦¦     ¦¦¦   ¦¦¦¦¦¦¦¦¦++¦¦¦¦¦¦++ +¦¦¦¦++      ¦¦¦¦¦++
	¦¦¦     ¦¦¦   ¦¦¦¦¦+--¦¦+¦¦+--¦¦+  +¦¦++      ¦¦+---+ 
	¦¦¦¦¦¦¦++¦¦¦¦¦¦++¦¦¦¦¦¦++¦¦¦¦¦¦++   ¦¦¦       ¦¦¦¦¦¦¦+
	+------+ +-----+ +-----+ +-----+    +-+       +------+
                                                      
	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

Module.Hooks = {
	"PlayerAuthed",
	"PlayerInformationLoaded"
}

function Module:PlayerAuthed( Pl )

	gmod.GetGamemode():LoadPlayerInformation( Pl )

end

function Module:PlayerInformationLoaded( Pl )

	gmod.GetGamemode():Print( "Module hook test" )

end