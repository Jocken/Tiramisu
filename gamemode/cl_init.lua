-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_init.lua
-- This file calls the rest of the script
-- As you can see, the clientside of CakeScript is pretty simple compared to the serverside.
-------------------------------

-- Set up the gamemode
DeriveGamemode( "sandbox" );
GM.Name = "Tiramisu";

-- Define global variables
CAKE = {  };
CAKE.Running = false;
CAKE.Loaded = false;
CAKE.Skin = "default"

CAKE.Thirdperson = CreateClientConVar( "rp_thirdperson", 0, true, true )
CAKE.RenderBody = CreateClientConVar( "rp_renderbody", 0, true, true )
CAKE.FirstPersonForward = CreateClientConVar( "rp_firstpersonforward", 0, true, true )
CAKE.FirstPersonUp = CreateClientConVar( "rp_firstpersonup", 7, true, true )
CAKE.Headbob = CreateClientConVar( "rp_headbob", 1, true, true )
CAKE.UseWhiteScreen = CreateClientConVar( "rp_whitescreen", 1, true, true )
CAKE.UseCalcView = CreateClientConVar( "rp_useview", 0, true, true )
CAKE.ViewRagdoll = false

CAKE.Clothing = "none"
CAKE.Helmet = "none"
CAKE.Gear = {}
CAKE.ClothingTbl = {}

CAKE.MyGroup = {}

CAKE.models = {  };
readysent = false;

require( "datastream" )

-- Client Includes
include( "shared.lua" );
include( "player_shared.lua" );
include( "cl_hud.lua" );
include( "cl_binds.lua" );
include( "cl_charactercreate.lua" );
include( "cl_playermenu.lua" );
include( "boneanimlib/cl_boneanimlib.lua" )
include( "boneanimlib/sh_boneanimlib.lua" )
include( "animations.lua" )

CAKE.Loaded = true;

-- Initialize the gamemode
function GM:Initialize( )

	CAKE.Running = true;

	self.BaseClass:Initialize( );

end

function GM:Think( )

	if( vgui and readysent == false ) then -- VGUI is initalized, tell the server we're ready for character creation.
	
		LocalPlayer( ):ConCommand( "rp_ready\n" );
		readysent = true;
		
	end
	
end

function GM:ForceDermaSkin()

	return CAKE.Skin
	
end

local function AddToChat( um )
	local string = um:ReadString()
	local font = um:ReadString()
	if aChat and aChat.AddChatLine then
		aChat.AddChatLine( "<color=135,209,255,255><font=" .. font .. ">" .. string .. "</font></color>" )
	end
end
usermessage.Hook( "tiramisuaddtochat", AddToChat )

function ConfirmCharRemove( um )
	local name = um:ReadString()
	local gender = um:ReadString()
	local description = um:ReadString()
	local age = um:ReadString()
	local model = um:ReadString()
	local id = um:ReadLong()
	PlayerInfo = vgui.Create( "DFrame" )
	PlayerInfo:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerInfo:SetSize( 536, 450 )
	PlayerInfo:SetTitle( "Confirm delete of: " .. name )
	PlayerInfo:SetVisible( true )
	PlayerInfo:SetDraggable( true )
	PlayerInfo:ShowCloseButton( false )
	PlayerInfo:MakePopup()
	PlayerPanel = vgui.Create( "DPanel", PlayerInfo )
	PlayerPanel:SetPos( 2, 23 )
	PlayerPanel:SetSize( 532, 425 )
	PlayerPanel.Paint = function()
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawRect( 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall() )
	end
	local namelabel = vgui.Create( "DLabel", PlayerPanel )
	namelabel:SetPos( 5, 3 )
	namelabel:SetSize( 150, 20 )
	namelabel:SetText( name )
	
	local genderlabel = vgui.Create( "DLabel", PlayerPanel )
	genderlabel:SetPos( 5, 63 )
	genderlabel:SetSize( 150, 20 )
	genderlabel:SetText( "Gender : " .. gender )
	
	local agelabel = vgui.Create( "DLabel", PlayerPanel )
	agelabel:SetPos( 5, 93 )
	agelabel:SetSize( 150, 20 )
	agelabel:SetText( "Age : " .. age )
	
	local desctext = vgui.Create( "DTextEntry", PlayerPanel )
	desctext:SetPos( 5 , 243 )
	desctext:SetSize( 200, 75 )
	desctext:SetMultiline( true )
	desctext:SetEditable( false )
	desctext:SetText( description )
	
	local mdlPanel = vgui.Create( "DModelPanel", PlayerPanel )
	mdlPanel:SetSize( 400, 400 )
	mdlPanel:SetPos( 180, -30 )
	mdlPanel:SetModel( model )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 100, 0, 30) );
	mdlPanel:SetLookAt( Vector( 0, 0, 30) );
	mdlPanel:SetFOV( 70 );
	function mdlPanel:LayoutEntity(Entity)

		self:RunAnimation()
		Entity:SetAngles( Angle( 0, 0, 0) )
		
	end
	
	local confirmbutton = vgui.Create( "DButton", PlayerPanel )
	confirmbutton:SetPos( 366, 375 )
	confirmbutton:SetSize( 150, 50 )
	confirmbutton:SetText( "Confirm Delete" )
	confirmbutton.DoClick = function( btn )
		LocalPlayer():ConCommand("rp_removechar " .. id);
		CreatePlayerMenu()
		PlayerInfo:Remove()
		PlayerInfo = nil;
	end
	
	local declinebutton = vgui.Create( "DButton", PlayerPanel )
	declinebutton:SetPos( 66, 375 )
	declinebutton:SetSize( 150, 50 )
	declinebutton:SetText( "Return to previous menu" )
	declinebutton.DoClick = function( btn )
		CreatePlayerMenu()
		PlayerInfo:Remove()
		PlayerInfo = nil;
	end
end
usermessage.Hook( "ConfirmCharRemoval", ConfirmCharRemove );


function message_GetPlayerInfo( um )
	local target = um:ReadEntity()
	local birthplace = um:ReadString()
	local gender = um:ReadString()
	local description = um:ReadString()
	local age = um:ReadString()
	local alignment = um:ReadString()
	PlayerInfo = vgui.Create( "DFrame" )
	PlayerInfo:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerInfo:SetSize( 536, 350 )
	PlayerInfo:SetTitle( "Character Info: " .. target:Nick() )
	PlayerInfo:SetVisible( true )
	PlayerInfo:SetDraggable( true )
	PlayerInfo:ShowCloseButton( true )
	PlayerInfo:MakePopup()
	PlayerPanel = vgui.Create( "DPanel", PlayerInfo )
	PlayerPanel:SetPos( 2, 23 )
	PlayerPanel:SetSize( 532, 325 )
	PlayerPanel.Paint = function()
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawRect( 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall() )
	end
	local namelabel = vgui.Create( "DLabel", PlayerPanel )
	namelabel:SetPos( 5, 3 )
	namelabel:SetSize( 150, 20 )
	namelabel:SetText( target:Nick() )
	
	local genderlabel = vgui.Create( "DLabel", PlayerPanel )
	genderlabel:SetPos( 5, 63 )
	genderlabel:SetSize( 150, 20 )
	genderlabel:SetText( "Gender : " .. gender )
	
	local namelabel = vgui.Create( "DLabel", PlayerPanel )
	namelabel:SetPos( 5, 33 )
	namelabel:SetSize( 150, 20 )
	namelabel:SetText( "Birthplace : " .. birthplace )
	
	local agelabel = vgui.Create( "DLabel", PlayerPanel )
	agelabel:SetPos( 5, 93 )
	agelabel:SetSize( 150, 20 )
	agelabel:SetText( "Age : " .. age )
	
	local alignlabel = vgui.Create( "DLabel", PlayerPanel )
	alignlabel:SetPos( 5, 153 )
	alignlabel:SetSize( 150, 20 )
	alignlabel:SetText( "Alignment : " .. alignment )
	
	local titlelabel = vgui.Create( "DLabel", PlayerPanel )
	titlelabel:SetPos( 5, 183 )
	titlelabel:SetSize( 150, 20 )
	titlelabel:SetText( target:GetNWString( "title" ) )
	
	local title2label = vgui.Create( "DLabel", PlayerPanel )
	title2label:SetPos( 5, 213 )
	title2label:SetSize( 150, 20 )
	title2label:SetText( target:GetNWString( "title2" ) )
	
	local desctext = vgui.Create( "DTextEntry", PlayerPanel )
	desctext:SetPos( 5 , 243 )
	desctext:SetSize( 200, 75 )
	desctext:SetMultiline( true )
	desctext:SetEditable( false )
	desctext:SetText( description )
	
	local mdlPanel = vgui.Create( "DModelPanel", PlayerPanel )
	mdlPanel:SetSize( 400, 400 )
	mdlPanel:SetPos( 180, -30 )
	mdlPanel:SetModel( target:GetModel() )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 100, 0, 30) );
	mdlPanel:SetLookAt( Vector( 0, 0, 30) );
	mdlPanel:SetFOV( 70 );
	function mdlPanel:LayoutEntity(Entity)

		self:RunAnimation()
		Entity:SetAngles( Angle( 0, 0, 0) )
		
	end
end
usermessage.Hook( "GetPlayerInfo", message_GetPlayerInfo );

function RunConcommand( um ) --Simple fix to garry's fuckup.
	
	local cmd = um:ReadString()
	local exp = string.Explode( " ", cmd )
	cmd = exp[1]
	local args = ""
	table.remove( exp, 1 )
	if #exp > 1 then
		args = table.concat( exp, " " )
	else
		args = exp[1] or ""
	end
	
	RunConsoleCommand( cmd, args )
	
end
usermessage.Hook( "runconcommand", RunConcommand )

function RemoveChar( um )
	
	local n = um:ReadLong();
	table.Empty( ExistingChars[ n ] )
	ExistingChars[ n ] = nil;
	
end
usermessage.Hook( "RemoveChar", RemoveChar );
