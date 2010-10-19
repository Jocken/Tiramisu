
include('shared.lua')

local lolpos

function ENT:Draw()

	if !self.Entity:GetDTBool(1) then
		return
	end

	if self.Entity:GetParent() == LocalPlayer() and GetViewEntity() == LocalPlayer() and !CAKE.MenuOpen then
		if !CAKE.UseCalcView:GetBool() then
			return
		end
		if !CAKE.Thirdperson:GetBool() then
			if !CAKE.RenderBody:GetBool() then
				return
			else
				if self.Entity:GetDTInt(1) == self.Entity:GetDTEntity( 1 ):LookupBone("ValveBiped.Bip01_Head1") then
					return
				end
			end
		end
	end
	
	if !lolpos then
		lolpos = self.Entity:GetParent():GetPos()
	end
	lolpos = LerpVector( 0.1, lolpos, self.Entity:GetParent():GetPos() )
	self.Entity:SetPos( lolpos )
	self.Entity:SetAngles( self.Entity:GetParent():GetAngles() )
	
	self.Entity:DrawModel()
	self.Entity:DrawShadow( true )
	
end

function ENT:Think()
	if ValidEntity( self.Entity:GetDTEntity( 1 ) ) then
		local position, angles = self.Entity:GetDTEntity( 1 ):GetBonePosition(self.Entity:GetDTInt(1))
		local newposition, newangles = LocalToWorld( self.Entity:GetDTVector(1), self.Entity:GetDTAngle(1), position, angles )
		self.Entity:SetPos(newposition)
		self.Entity:SetAngles(newangles)
		self.Entity:SetModelScale( self.Entity:GetDTVector(2) )
	end
end



