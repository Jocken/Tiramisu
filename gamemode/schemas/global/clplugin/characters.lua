CLPLUGIN.Name = "Character Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"
local function OpenCharacter()

	PlayerMenu = vgui.Create( "DFrame" )
	--PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Characters" )
	--PlayerMenu:SetBackgroundBlur( true )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	PlayerMenu:MakePopup()
	function PlayerMenu:Paint()
	end
	
	CharPanel = vgui.Create( "DPanelList", PlayerMenu )
	CharPanel:SetSize( 640,450 )
	CharPanel:SetPos( 0, 23 )
	CharPanel:SetPadding(20);
	CharPanel:SetSpacing(10);
	CharPanel:EnableVerticalScrollbar();
	CharPanel:EnableHorizontal(false);

	local label = vgui.Create("DLabel");
	label:SetText("Click your character to select it");
	CharPanel:AddItem(label);
	
	local widthnshit = 600
	local numberofchars = table.getn( ExistingChars )
	local modelnumber = {}
	
	local function AddCharacterModel( n, model )
		
		local mdlpanel = modelnumber[n]
		
		mdlpanel = vgui.Create( "DModelPanel" )
		mdlpanel:SetSize( 200, 180 )
		mdlpanel:SetModel( model )
		mdlpanel:SetAnimSpeed( 0.0 )
		mdlpanel:SetAnimated( false )
		mdlpanel:SetAmbientLight( Color( 50, 50, 50 ) )
		mdlpanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
		mdlpanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
		mdlpanel:SetCamPos( Vector( 100, 0, 40 ) )
		mdlpanel:SetLookAt( Vector( 0, 0, 40 ) )
		mdlpanel:SetFOV( 70 )

		mdlpanel.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("Trebuchet18");
			surface.SetTextPos( surface.GetTextSize(ExistingChars[n]['name']) , 0);
			surface.DrawText(ExistingChars[n]['name'])
		end
		
		function mdlpanel:OnMousePressed()
			local Options = DermaMenu()
			Options:AddOption("Select Character", function() 
				LocalPlayer():ConCommand("rp_selectchar " .. n);
				LocalPlayer().MyModel = ""
				PlayerMenu:Remove();
				PlayerMenu = nil;
				CAKE.MenuOpen = false
			end )
			Options:AddOption("Delete Character", function() 
				LocalPlayer():ConCommand("rp_confirmremoval " .. n);
				PlayerMenu:Remove();
				PlayerMenu = nil;
			end )
			Options:Open()
		end

		function mdlpanel:LayoutEntity(Entity)

			self:RunAnimation();
			
		end
		function InitAnim()
		
			if(mdlpanel.Entity) then		
				local iSeq = mdlpanel.Entity:LookupSequence( "idle_angry" );
				mdlpanel.Entity:ResetSequence(iSeq);
			
			end
			
		end
		
		InitAnim()
		CharPanel:AddItem(mdlpanel);
	
	end
	
	
	for k, v in pairs(ExistingChars) do
		AddCharacterModel( k, v['model'] )
		
	end
	
	local newchar = vgui.Create("DButton");
	newchar:SetSize(100, 25);
	newchar:SetText("New Character");
	newchar.DoClick = function ( btn )
		CAKE.NextStep()
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	CharPanel:AddItem( newchar )

end

local function CloseCharacter()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Characters", OpenCharacter, CloseCharacter )

function CLPLUGIN.Init()
	
end