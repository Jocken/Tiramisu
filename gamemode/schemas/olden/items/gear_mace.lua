ITEM.Name = "A mace";
ITEM.Class = "gear_mace";
ITEM.Description = "Crush your enemy to pulp!";
ITEM.Model = "models/soulcalibur4/1damace1.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle(0,0,0 )
ITEM.Bone = "left hand"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
