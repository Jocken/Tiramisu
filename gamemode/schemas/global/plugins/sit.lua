PLUGIN.Name = "Sitting"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles the process of putting your ass on top of something"; -- The description or purpose of the plugin

CAKE.Chairs = {
	[ "models/props_c17/furniturecouch001a.mdl" ] = {
			{ ["pos"] = Vector( 0, 0, 0 ), ["angles"] = Vector( 0, 0, 0 ) },
			{ ["pos"] = Vector( 0, 0, 0 ), ["angles"] = Vector( 0, 0, 0 ) }
		}
}

function CAKE.EditChair( mdl, tbl )
	if CAKE.Chairs then
		for k, v in pairs( CAKE.Chairs ) do
			if k == mdl then
				CAKE.Chairs[ mdl ] = tbl
			end
		end
	end
end

function CAKE.SaveChairs()
	PrintTable( CAKE.Chairs )
	local keys = glon.encode(CAKE.Chairs);
	file.Write( CAKE.Name .. "/chairs.txt", keys )
end

function CAKE.LoadChairs()
	if file.Exists( CAKE.Name .. "/chairs.txt" ) then
		CAKE.Chairs = glon.decode(file.Read( CAKE.Name .. "/chairs.txt" ))
	end
	PrintTable( CAKE.Chairs )
end

local function LoadChairs()
	CAKE.LoadChairs()
end
hook.Add( "InitPostEntity", "TiramisuLoadChairs", LoadChairs )

function CAKE.IsChair( ent )
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_static" then
		for k, v in pairs( CAKE.Chairs ) do
			if string.lower( ent:GetModel() ) == string.lower( k ) then
				print( "yep, it's chair." )
				return true
			end
		end
	end
	return false
end

local function ccSitDown( ply, cmd, args )
	local trace = ply:GetEyeTrace( )
	local ent = trace.Entity
	local sitnum
	local sitpos
	local sitang
	local hassit = false
	local newposition, newangles
	local tbl
	
	if  ValidEntity( ent ) then
		print( ent:GetClass() )
	end
	
	if ValidEntity( ent ) and CAKE.IsChair( ent ) and !ply:GetNWBool( "sittingchair", false ) and !ply:GetNWBool( "sittingground", false ) then		
		if !ent.PeopleSitting then
			ent.PeopleSitting = {}
		end
		tbl = CAKE.Chairs[ string.lower( ent:GetModel() ) ] 
		sitnum = #tbl
		for i=1, sitnum do
			if !ent.PeopleSitting[ i ] then
				ent.PeopleSitting[ i ] = ply
				ply.SitSpot = i
				hassit = true
				ply:SetNWBool( "sittingchair", true )
				ply:SetParent( ent )
				ply:Freeze( true )
				ply:SetLocalPos(CAKE.Chairs[ ent:GetModel() ][i]["pos"])
				ply:SetLocalAngles(CAKE.Chairs[ ent:GetModel() ][i]["angles"])
			end
		end
		if hassit then
			CAKE.SendChat( ply, "Use !stand to get back on your feet." )
		else
			CAKE.SendChat( ply, "No room to sit here." )
		end
	else
		if ply:OnGround() then
			ply:SetNWBool( "sittingground", true )
			ply:Freeze( true )
			CAKE.SendChat( ply, "Use !stand to get back on your feet." )
		end
	end
	
end
concommand.Add( "rp_sit", ccSitDown )

local function ccStandUp( ply, cmd, args )
	if ply:GetNWBool( "sittingchair", false ) then
		ply:GetParent().PeopleSitting[ ply.SitSpot ] = nil
		ply:SetNWBool( "sittingchair", false )
	elseif ply:GetNWBool( "sittingground", false ) then
		ply:SetNWBool( "sittingground", false )
	end
	ply:SetParent()
	ply:SetPos( ply:GetPos() + Vector( 0, 0, 10 )  )
	ply:Freeze( false )
end
concommand.Add( "rp_stand", ccStandUp )

local function ccEditSit( ply, cmd, args )
	
	local mdl = ""
	local seat = 1
	local vec = Vector( 0, 0, 0 )
	local ang = Angle( 0, 0, 0 )
	local tbl = {}
	
	if args[1] then
		mdl = string.lower( args[1] )
	end
	if args[2] and args[2] != "none" then
		seat = tonumber( args[2] )
	end
	if args[3] and args[3] != "none" then
		local sep = string.Explode( ",", args[3] )
		vec = Vector( tonumber(sep[1]),tonumber(sep[2]),tonumber(sep[3]) )
	else
		if CAKE.Chairs and CAKE.Chairs[ mdl ] and CAKE.Chairs[ mdl ][ seat ] then
			vec = CAKE.Chairs[ mdl ][ seat ][ "pos" ]
		end
	end
	if args[4] and args[4] != "none" then
		local sep = string.Explode( ",", args[4] )
		ang = Angle( tonumber(sep[1]),tonumber(sep[2]),tonumber(sep[3]) )
	else
		if CAKE.Chairs and CAKE.Chairs[ mdl ] and CAKE.Chairs[ mdl ][ seat ] then
			ang = CAKE.Chairs[ mdl ][ seat ][ "angles" ]
		end
	end
	
	tbl = {
		["pos"] = vec,
		["angles"] = ang
	}
	
	if CAKE.Chairs and CAKE.Chairs[ mdl ] and CAKE.Chairs[ mdl ] then
		CAKE.Chairs[ mdl ][ seat ] = tbl
	end
	
	CAKE.SaveChairs()
	
end

local function ccCreateSit( ply, cmd, args )
	
	local mdl = string.lower( args[1] )
	if CAKE.Chairs and !CAKE.Chairs[ mdl ] then
		CAKE.Chairs[ mdl ] = {}
		CAKE.Chairs[ mdl ][ 1 ] = { ["pos"] = Vector( 0, 0, 0 ), ["angles"] = Vector( 0, 0, 0 ) }
	end
	
	CAKE.SaveChairs()
	
end

function PLUGIN.Init()
	CAKE.AdminCommand( "createchair", ccCreateSit, "Add a chair", true, true, 2 );
	CAKE.AdminCommand( "editchair", ccEditSit, "Edit a chair's coordinates", true, true, 2 );
end