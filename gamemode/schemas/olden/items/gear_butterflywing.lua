ITEM.Name = "Butterfly Wings";
ITEM.Class = "gear_butterflywing";
ITEM.Description = "Just like you always wanted to be!";
ITEM.Model = "models/Olden/butterfly_wings.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 0,0,0 )
ITEM.OffsetAngle = Angle( 0,0,0 )
ITEM.Bone = "chest"
ITEM.Weight = 0

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
