PLUGIN.Name = "Admin Commands"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "A set of default admin commands"; -- The description or purpose of the plugin

function Admin_AddDoor(ply, cmd, args)
	
	local tr = ply:GetEyeTrace()
	local trent = tr.Entity;
	
	if(!CAKE.IsDoor(trent)) then ply:PrintMessage(3, "You must be looking at a door!"); return; end

	if(table.getn(args) < 1) then ply:PrintMessage(3, "Specify a doorgroup!"); return; end
	
	local pos = trent:GetPos()
	local Door = {}
	Door["x"] = math.ceil(pos.x);
	Door["y"] = math.ceil(pos.y);
	Door["z"] = math.ceil(pos.z);
	Door["group"] = args[1];
	
	table.insert(CAKE.Doors, Door);
	
	CAKE.SendChat(ply, "Door added");
	
	local keys = util.TableToKeyValues(CAKE.Doors);
	file.Write(CAKE.Name .. "/MapData/" .. game.GetMap() .. ".txt", keys);
	
end

-- rp_admin kick "name" "reason"
function Admin_Kick( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin kick \"name\" \"reason\" )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	
	local pl = CAKE.FindPlayer( plyname );
	
	if( pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"" .. reason .. "\"\n" );
		
		CAKE.AnnounceAction( ply, "kicked " .. pl:Nick( ) );
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end

-- rp_admin ban "name" "reason" minutes
function Admin_Ban( ply, cmd, args )

	if( #args != 3 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin ban \"name\" \"reason\" minutes )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	local mins = tonumber( args[ 3 ] );
	
	if(mins > CAKE.ConVars[ "MaxBan" ]) then
	
		CAKE.SendChat( ply, "Max minutes is " .. CAKE.ConVars[ "MaxBan" ] .. " for regular ban. Use superban.");
		return;
	
	end
	
	local pl = CAKE.FindPlayer( plyname );
	
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" );
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" );
		game.ConsoleCommand( "writeid\n" );
		
		CAKE.AnnounceAction( ply, "banned " .. pl:Nick( ) );
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end
function Admin_Observe( ply, cmd, args )

	   if( not ply:GetNWBool( "observe" )) then

		   ply:GodEnable();
		   for k, v in pairs( ply.Clothing ) do
			   if type( v ) != "table" then --So it isn't gear.
				   if ValidEntity( v ) then
					   v:SetNoDraw( true );
				   end
			   end
		   end
		   
		   if( ply.Clothing.Gear ) then
			   for k, v in pairs( ply.Clothing.Gear ) do
				   for k2, v2 in pairs( ply.Clothing.Gear[ v ] ) do
					   if ValidEntity( v2 ) then
						   v2:SetNoDraw( true );
					   end
				   end
			   end
		   end
		   
		   if( ValidEntity( ply:GetActiveWeapon() ) ) then
			   ply:GetActiveWeapon():SetNoDraw( true );
		   end
		   
		   ply:SetNotSolid( true );
		   ply:SetMoveType( 8 );
		   
		   ply:SetNWBool( "observe", true )
		   
	   else

		   ply:GodDisable();
		   for k, v in pairs( ply.Clothing ) do
			   if type( v ) != "table" then --So it isn't gear.
				   if ValidEntity( v ) then
					   v:SetNoDraw( false );
				   end
			   end
		   end
		   
		   if( ply.Clothing.Gear ) then
			   for k, v in pairs( ply.Clothing.Gear ) do
				   for k2, v2 in pairs( ply.Clothing.Gear[ v ] ) do
					   if ValidEntity( v2 ) then
						   v2:SetNoDraw( false );
					   end
				   end
			   end
		   end
		   
		   if( ply:GetActiveWeapon() ) then
			   ply:GetActiveWeapon():SetNoDraw( false );
		   end
		   
		   ply:SetNotSolid( false );
		   ply:SetMoveType( 2 );
		   
		   ply:SetNWBool( "observe", false )
		   
	   end

end

function Admin_Noclip( ply, cmd, args )
	   if( not ply:GetTable().Noclip ) then



		   ply:GodEnable();
		   
		   ply:SetNotSolid( true );
		   ply:SetMoveType( 8 );
		   
		   ply:GetTable().Observe = true;
		   
	   else

		   ply:GodDisable();
		   
		   ply:SetNotSolid( false );
		   ply:SetMoveType( 2 );
		   
		   ply:GetTable().Noclip = false;
		   
	   end
end

-- rp_admin superban "name" "reason" minutes
function Admin_SuperBan( ply, cmd, args )

	if( #args != 3 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin superban \"name\" \"reason\" minutes )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	local mins = tonumber( args[ 3 ] );
	
	local pl = CAKE.FindPlayer( plyname );
	
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" );
		
		if( mins == 0 ) then
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Permanently banned ( " .. reason .. " )\"\n" );
			CAKE.AnnounceAction( ply, "permabanned " .. pl:Nick( ) );
	
		else
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" );
			CAKE.AnnounceAction( ply, "banned " .. pl:Nick( ) );
			
		end
		
		game.ConsoleCommand( "writeid\n" );
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end

function Admin_SetConVar( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setvar \"varname\" \"value\" )" );
		return;
		
	end
	
	if( CAKE.ConVars[ args[ 1 ] ] ) then
	
		local vartype = type( CAKE.ConVars[ args [ 1 ] ] );
		
		if( vartype == "string" ) then
		
			CAKE.ConVars[ args[ 1 ] ] = tostring(args[ 2 ]);
			
		elseif( vartype == "number" ) then
		
			CAKE.ConVars[ args[ 1 ] ] = CAKE.NilFix(tonumber(args[ 2 ]), 0); -- Don't set a fkn string for a number, dumbass! >:<
		
		elseif( vartype == "table" ) then
		
			CAKE.SendChat( ply, args[ 1 ] .. " cannot be changed, it is a table." ); -- This is kind of like.. impossible.. kinda. (Or I'm just a lazy fuck)
			return;
			
		end
		
		CAKE.SendChat( ply, args[ 1 ] .. " set to " .. args[ 2 ] );
		CAKE.CallHook( "SetConVar", ply, args[ 1 ], args[ 2 ] );
		
	else
	
		CAKE.SendChat( ply, args[ 1 ] .. " is not a valid convar! Use rp_admin listvars" );
		
	end
	
end

function Admin_ListVars( ply, cmd, args )

	CAKE.SendChat( ply, "---List of CakeScript ConVars---" );
	
	for k, v in pairs( CAKE.ConVars ) do
		
		CAKE.SendChat( ply, k .. " - " .. tostring(v) );
		
	end
	
end

function Admin_SetFlags( ply, cmd, args)
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	table.remove(args, 1); -- Get rid of the name
	
	CAKE.SetCharField(target, "flags", args); -- KLOL!
	
	CAKE.SendChat( ply, target:Name() .. "'s flags were set to \"" .. table.concat(args, " ") .. "\"" );
	CAKE.SendChat( target, "Your flags were set to \"" .. table.concat(args, " ") .. "\" by " .. ply:Name());
	
end

function Admin_Help( ply, cmd, args )

	CAKE.SendChat( ply, "---List of CakeScript Admin Commands---" );
	
	for cmdname, cmd in pairs( CAKE.AdminCommands ) do
	
		local s = cmdname .. " \"" .. cmd.desc .. "\"";
		
		if(cmd.CanRunFromConsole) then
		
			s = s .. " console";

		else
		
			s = s .. " noconsole";
			
		end
		
		if(cmd.CanRunFromAdmin) then
		
			s = s .. " admin";
			
		end
		
		if(cmd.SuperOnly) then
		
			s = s .. " superonly";
			
		end
		
		CAKE.SendChat( ply, s );
		
	end
	
end

function Admin_SetRank( ply, cmd, args)

	if #args != 2 then CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin setrank \"name\" \"rank\" )") return end
	
	args[1] = CAKE.FindPlayer(args[1])
	if !args[1] then CAKE.SendChat(ply, "Target not found!") return end
	
	if !CAKE.AdminRanks[args[2]] then CAKE.SendChat(ply, "Invalid rank!") else
		CAKE.SetPlayerField( args[1], "adrank", args[2])
		CAKE.AnnounceAction( ply, "made " .. args[1]:Nick( ).. " a " ..args[2] );
	end

end

function Admin_AddSpawn( ply, cmd, args)
	
	if #args == 1 then
		local pos = ply:GetPos()
		local ang = ply:EyeAngles( )
		local team = team.GetName(ply:Team())
		CAKE.AddSpawn(pos, ang, team)
	else
		local pos = ply:GetPos()
		local ang = ply:EyeAngles( )
		CAKE.AddSpawn(pos, ang)
	end
	
end

function Admin_SetBuyGroups( ply, cmd, args ) 
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	table.remove(args, 1); -- Get rid of the name
	
	CAKE.SetCharField(target, "buygroups", args); -- KLOL!
	
	CAKE.SendChat( ply, target:Name() .. "'s buy groups were set to \"" .. table.concat(args, " ") .. "\"" );
	CAKE.SendChat( target, "Your buy groups were set to \"" .. table.concat(args, " ") .. "\" by " .. ply:Name());


end
	
function Admin_AddStash( ply, cmd, args)
	
		local pos = ply:GetPos()
		local ang = ply:EyeAngles( )
		CAKE.AddStash(pos, ang)
	
end

function Admin_SetMoney( ply, cmd, args )

	local target = CAKE.FindPlayer(args[1])
	CAKE.SetCharField( target, "money", args[2] )
		
end

function Admin_ForceClothing( ply, cmd, args)
	   
	   local target = CAKE.FindPlayer(args[1])
	   
	   if(target != nil and target:IsValid() and target:IsPlayer()) then
		   -- klol
	   else
		   CAKE.SendChat( ply, "Target not found!" );
		   return;
	   end
	   
	   CAKE.SetCharField(target, "model", args[2] );
	   if args[3] then
		   CAKE.SetCharField(target, "gloves", args[3] );
	   end
	   
end

function Admin_HeadRatio( ply, cmd, args)
	   
	   local target = CAKE.FindPlayer(args[1])
	   
	   if(target != nil and target:IsValid() and target:IsPlayer()) then
		   -- klol
	   else
		   CAKE.SendChat( ply, "Target not found!" );
		   return;
	   end
	   
	   CAKE.SetCharField(target, "headratio", tonumber( args[2] ) );
	   
end

function Admin_ForceJoin( ply, cmd, args)

		local target = CAKE.FindPlayer(args[1])
	   
		if(target != nil and target:IsValid() and target:IsPlayer()) then
			-- klol
		else
			CAKE.SendChat( ply, "Target not found!" );
			return;
		end
	   
		CAKE.SetCharField(target, "group", args[2] );
	   	CAKE.SetCharField( target, "grouprank", args[3] )
		ply.GetLoadout = true
		
end

function Admin_CreateItem( ply, cmd, args ) -- Why the fuck wasn't this here on the first place...

	CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
	
end
	
-- Let's make some ADMIN COMMANDS!
function PLUGIN.Init( )

	CAKE.ConVars[ "MaxBan" ] = 300; -- What is the maximum ban limit for regular admins?
	
	CAKE.AddAdminRank( "Event Cooirdinator", 1)
	CAKE.AddAdminRank( "Trial Moderator", 2)
	CAKE.AddAdminRank( "Moderator", 3)
	CAKE.AddAdminRank( "Administrator", 4)
	CAKE.AddAdminRank( "Super Administrator", 5)
	
	CAKE.AdminCommand( "help", Admin_Help, "List of all admin commands", true, true, 1 );
	CAKE.AdminCommand( "observe", Admin_Observe, "Enter observe mode", true, true, 1 );
	CAKE.AdminCommand( "noclip", Admin_Noclip, "Enter admin noclip mode", true, true, 1 );
	CAKE.AdminCommand( "kick", Admin_Kick, "Kick someone on the server", true, true, 2 );
	CAKE.AdminCommand( "ban", Admin_Ban, "Ban someone on the server", true, true, 3 );
	CAKE.AdminCommand( "forceclothing", Admin_ForceClothing, "Force a model on someone", true, true, 3 );
	CAKE.AdminCommand( "headratio", Admin_HeadRatio, "Change the size of someone's head", true, true, 3 );
	CAKE.AdminCommand( "setbuygroup", Admin_SetBuyGroups, "Set someone's buy groups", true, true, 3 );
	CAKE.AdminCommand( "superban", Admin_SuperBan, "Ban someone on the server ( Permanent allowed )", true, true, 4 );
	CAKE.AdminCommand( "setconvar", Admin_SetConVar, "Set a Convar", true, true, 4 );
	CAKE.AdminCommand( "listvars", Admin_ListVars, "List convars", true, true, 4 );
	CAKE.AdminCommand( "setflags", Admin_SetFlags, "Set a players flags", true, true, 3 );
	CAKE.AdminCommand( "forcejoin", Admin_ForceJoin, "Forces a player to join a group", true, true, 3 );
	CAKE.AdminCommand( "adddoor", Admin_AddDoor, "Add a door to a doorgroup", true, true, 4 );
	CAKE.AdminCommand( "createitem", Admin_CreateItem, "Creates an item", true, true, 4 );
	CAKE.AdminCommand( "setrank", Admin_SetRank, "Set the rank of another player", true, true, 5 )
	CAKE.AdminCommand( "setmoney", Admin_SetMoney, "Set the money of another player", true, true, 5 )
	CAKE.AdminCommand( "addspawn", Admin_AddSpawn, "Add a new spawn point.", true, true, 4 )
	CAKE.AdminCommand( "addstash", Admin_AddStash, "Add a new stash point.", true, true, 4 )
	
end
