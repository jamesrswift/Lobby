// GameServer Blooo

-- 01FF - AA - BB - X

-- 01FF = Our protocol Identifier
-- AA = Our Protocol Version ( futur updates ?, def 01 )
-- BB = Procedure to be taken ( 255 possible )
-- X = null terminated String of undefined length

if !Hex then return end -- We needs hex
if !MultiServer then MultiServer = { }; end

Msg( "\nLoading MultiServer\n" )

MultiServer.Protocol = 511; -- 0x01FF

-- Procedures

MultiServer.Procedures = { };

function MultiServer.AddProcedure( ID, Version , Function )

	if MultiServer.Procedures[ ID ] then return end
	
	MultiServer.Procedures[ ID ] = { Version , Function };

end

function MultiServer.ProcedureExists( ID , Version )

	return ( MultiServer.Procedures[ ID ] != nil and MultiServer.Procedures[ ID ][1] == Version );

end

function MultiServer.CallProcedure( ID , Argument )

	return pcall( MultiServer.Procedures[ ID ][2] , Argument );

end

-- Get

MultiServer.SUCCESS = -1;

MultiServer.ERROR_WRONG_PROTOCOL = 0;
MultiServer.ERROR_MALFORMED = 1;
MultiServer.ERROR_NO_PROCEDURE = 2;

function MultiServer.RecievedInformation( Info )

	local Data = Hex( Info );
	
	if ( Data:CanGet( 4 ) ) then
	
		local Identifier = Data:GetInt( 4 );
		if Identifier != MultiServer.Protocol then return MultiServer.ERROR_WRONG_PROTOCOL; end
		
		local Version = Data:GetInt( 2 );
		local Procedure = Data:GetInt( 2 );
		local Argument = Data:GetString();
		
		//print( "ID : " .. Identifier, "Ver : " .. Version, "Proc : " .. Procedure, "Arg : " .. Argument)
		
		if ( MultiServer.ProcedureExists( Procedure , Version ) ) then
		
			MultiServer.CallProcedure( Procedure , Argument );
		
		else
		
			return MultiServer.ERROR_NO_PROCEDURE;
	
		end

	else
	
		return MultiServer.ERROR_MALFORMED;
		
	end
	
	return MultiServer.SUCCESS

end

-- Send

function MultiServer.EncodeInformation( Version , Procedure, Argument )

	local Data = Hex();
	Data:WriteString( Argument );
	Data:WriteInt( Procedure , 2 );
	Data:WriteInt( Version , 2 );
	Data:WriteInt( MultiServer.Protocol , 4 );
	
	return Data:GetData();

end
