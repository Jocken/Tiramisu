ITEM.Name = "Amulet";
ITEM.Class = "gear_amulet4";
ITEM.Description = "Purdy.";
ITEM.Model = "models/props_tes/amulets/arnoras_fake.mdl";
ITEM.Purchaseable = false;	
ITEM.Price = 0;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end