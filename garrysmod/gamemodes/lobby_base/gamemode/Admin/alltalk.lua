/* Usage: Bind somthing to +alltalk , And speak
Note: Only admins can speak!
*/

hook.Add("PlayerCanHearPlayersVoice", "AdminAllTalk", function(listener, talker)
	if talker.AllTalkActive == true then
		return true
	end		
end)

concommand.Add("+alltalk", function( ply )
	if ply:IsAdmin() then
		ply.AllTalkActive = true
	end
end )

concommand.Add("-alltalk", function( ply )
	if ply:IsAdmin() then
		ply.AllTalkActive = nil
	end
end )