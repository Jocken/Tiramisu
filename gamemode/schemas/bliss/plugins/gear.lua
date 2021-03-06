PLUGIN.Name = "Gear"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles the stuff that you stick on yourself"; -- The description or purpose of the plugin

--Thanks to the PAC team for this list.
local BoneList = {
	["pelvis"			] = "ValveBiped.Bip01_Pelvis"		,
	["stomach"			] = "ValveBiped.Bip01_Spine"		,
	["lower back"		] = "ValveBiped.Bip01_Spine1"		,
	["chest"			] = "ValveBiped.Bip01_Spine2"		,
	["upper back"		] = "ValveBiped.Bip01_Spine4"		,
	["neck"				] = "ValveBiped.Bip01_Neck1"		,
	["head"				] = "ValveBiped.Bip01_Head1"		,
	["right clavicle"	] = "ValveBiped.Bip01_R_Clavicle"	,
	["right upper arm"	] = "ValveBiped.Bip01_R_UpperArm"	,
	["right forearm"	] = "ValveBiped.Bip01_R_Forearm"	,
	["right hand"		] = "ValveBiped.Bip01_R_Hand"		,
	["left clavicle"	] = "ValveBiped.Bip01_L_Clavicle"	,
	["left upper arm"	] = "ValveBiped.Bip01_L_UpperArm"	,
	["left forearm"		] = "ValveBiped.Bip01_L_Forearm"	,
	["left hand"		] = "ValveBiped.Bip01_L_Hand"		,
	["right thigh"		] = "ValveBiped.Bip01_R_Thigh"		,
	["right calf"		] = "ValveBiped.Bip01_R_Calf"		,
	["right foot"		] = "ValveBiped.Bip01_R_Foot"		,
	["right toe"		] = "ValveBiped.Bip01_R_Toe0"		,
	["left thigh"		] = "ValveBiped.Bip01_L_Thigh"		,
	["left calf"		] = "ValveBiped.Bip01_L_Calf"		,
	["left foot"		] = "ValveBiped.Bip01_L_Foot"		,
	["left toe"			] = "ValveBiped.Bip01_L_Toe0"		
}

function CAKE.BoneShorttoFull( bone )
	return BoneList[ bone ]
end

function CAKE.BoneFulltoShort( bone )
	for k, v in pairs( BoneList ) do
		if v == bone then
			return k
		end
	end
end

function CAKE.HandleGear( ply, item, bone, offset, angle, scale )

		local bone = bone or CAKE.ItemData[ item ].Bone or "head"
		
		if !ply.Gear then
			ply.Gear = {}
		end
		
		if ply.Gear[ bone ] then
			CAKE.RemoveGear( ply, bone )
		end
		
		ply.Gear[ bone ] = {}
		local model = CAKE.ItemData[ item ].Model
		local offset = offset or CAKE.ItemData[ item ].Offset or Vector( 0, 0, 0 )
		local angle = angle or CAKE.ItemData[ item ].OffsetAngle or Angle( 0, 0, 0 )
		local scale = scale or CAKE.ItemData[ item ].Scale or Vector( 1, 1, 1 )
		
		ply.Gear[ bone ][ "entity" ] = ents.Create( "player_gear" )
		ply.Gear[ bone ][ "entity" ]:SetModel( model )
		ply.Gear[ bone ][ "entity" ]:SetParent( ply )
		ply.Gear[ bone ][ "entity" ]:SetPos( ply:GetPos() )
		ply.Gear[ bone ][ "entity" ]:SetAngles( ply:GetAngles() )
		ply.Gear[ bone ][ "entity" ]:SetDTInt( 1, ply:LookupBone( CAKE.BoneShorttoFull( bone ) ) )
		ply.Gear[ bone ][ "entity" ]:SetDTEntity( 1, ply )
		ply.Gear[ bone ][ "entity" ]:SetDTAngle( 1, angle )
		ply.Gear[ bone ][ "entity" ]:SetDTVector( 1, offset )
		ply.Gear[ bone ][ "entity" ]:SetDTVector( 2, scale )
		ply.Gear[ bone ][ "entity" ]:SetDTBool( 1, true )
		ply.Gear[ bone ][ "entity" ]:Spawn()
		ply.Gear[ bone ][ "item" ] = item
		
end
	
function CAKE.RemoveGear( ply, bone )

	if ply.Gear[ bone ] then
		ply.Gear[ bone ][ "entity" ]:Remove()
		ply.Gear[ bone ] = nil
	end
	
end
	
function CAKE.RemoveAllGear( ply )
	
	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			CAKE.RemoveGear( ply, k )
		end
	end
		
	ply.Gear = {}
end

function CAKE.RemoveGearItem( ply, item )

	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			if v[ "item" ] == item then
				CAKE.RemoveGear( ply, k )
			end
			break
		end
	end
	
end

local function ccSetGear( ply, cmd, args )
	
	local item = args[1]
	local bone = args[2] or CAKE.ItemData[ item ].Bone or "head"
	local offset
	local angle
	local scale
	
	if args[3] then
		offset = Vector( tonumber( args[3] ), tonumber( args[4] ), tonumber( args[5] ) )
	else
		offset = CAKE.ItemData[ item ].Offset or Vector( 0, 0, 0 )
	end
	
	if args[6] then
		angle = Angle( tonumber( args[6] ), tonumber( args[7] ), tonumber( args[8] ) )
	else
		angle = CAKE.ItemData[ item ].OffsetAngle or Angle( 0, 0, 0 )
	end
	
	if args[9] then
		scale = Vector( tonumber( args[9] ), tonumber( args[10] ), tonumber( args[11] ) )
	else
		scale = CAKE.ItemData[ item ].Scale or Vector( 1, 1, 1 )
	end
	
	CAKE.RemoveGear( ply, bone )
	CAKE.HandleGear( ply, item, bone, offset, angle, scale )

end
concommand.Add( "rp_setgear", ccSetGear )

local function ccRemoveGear( ply, cmd, args )
	
	if( args[1] ) then
		CAKE.RemoveGear( ply, args[1] )
	else
		CAKE.RemoveAllGear( ply )
	end

end
concommand.Add( "rp_removegear", ccRemoveGear )

local function ccEditGear( ply, cmd, args )

	local bone = args[1]
	local offset
	local angle
	local scale
	local visible
	
	if args[2] and args[2] != "none" then
		local exp = string.Explode( ",", args[2] )
		offset = Vector( exp[1], exp[2], exp[3] )
	else
		offset = ply.Gear[ bone ][ "entity" ]:GetDTVector( 1 )
	end
	
	if args[3] and args[3] != "none" then
		local exp = string.Explode( ",", args[3] )
		angle = Angle( exp[1], exp[2], exp[3] )
	else
		angle = ply.Gear[ bone ][ "entity" ]:GetDTAngle( 1 )
	end
	
	if args[4] and args[4] != "none" then
		local exp = string.Explode( ",", args[4] )
		scale = Vector( exp[1], exp[2], exp[3] )
	else
		scale = ply.Gear[ bone ][ "entity" ]:GetDTVector( 2 )
	end
	
	if args[5] then
		visible = util.tobool( args[5] )
	else
		visible = ply.Gear[ bone ][ "entity" ]:GetDTBool( 1 )
	end
	
	ply.Gear[ bone ][ "entity" ]:SetDTVector( 1, offset )
	ply.Gear[ bone ][ "entity" ]:SetDTVector( 2, scale )
	ply.Gear[ bone ][ "entity" ]:SetDTAngle( 1, angle )
	ply.Gear[ bone ][ "entity" ]:SetDTBool( 1, visible )

end
concommand.Add( "rp_editgear", ccEditGear )

local meta = FindMetaTable( "Player" )

function meta:HideActiveWeapon()
	
	local wep = self:GetActiveWeapon()
	if ValidEntity( wep ) and !self:GetNWBool( "observe" ) then
		local class = wep:GetClass()
		if self.Gear then
			for k, v in pairs( self.Gear ) do
				if v[ "item" ] == class and v[ "entity" ]:GetParent() == self then
					v[ "entity" ]:SetDTBool( 1, false )
				else
					v[ "entity" ]:SetDTBool( 1, true)
				end
			end
		end
	end

end

function CAKE.SaveGear( ply )
	
	local tbl = table.Copy( ply.Gear )
	
	for k, v in pairs( tbl ) do
		v[ "offset" ] = v[ "entity" ]:GetDTVector( 1 )
		v[ "angle" ] = v[ "entity" ]:GetDTAngle( 1 )
		v[ "scale" ] = v[ "entity" ]:GetDTVector( 2 )
		v[ "entity" ] = nil
	end
	
	CAKE.SetCharField( ply, "gear", tbl )
	datastream.StreamToClients( ply, "recievegear",  ply.Gear )
	
	PrintTable( CAKE.GetCharField( ply, "gear" ) )
	
end

function CAKE.RestoreGear( ply )
	
	if ply:IsCharLoaded() then
		local tbl = CAKE.GetCharField( ply, "gear" )
		PrintTable( tbl )
		for k, v in pairs( tbl ) do
			if ply:HasItem( v[ "item" ] ) then
				CAKE.HandleGear( ply, v[ "item" ], k, v[ "offset" ], v[ "angle" ], v[ "scale" ] )
			end
		end
		datastream.StreamToClients( ply, "recievegear",  ply.Gear )
	end
	
end

function PLUGIN.Init()
	
	CAKE.AddDataField( 2, "gear", {} ); --Whatever the fuck else you're wearing.
	
end