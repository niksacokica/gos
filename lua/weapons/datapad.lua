SWEP.PrintName = "Datapad"
SWEP.Author = "niksacokica"
SWEP.Category = "DATAPAD"

SWEP.Spawnable= true
SWEP.AdminOnly = false

SWEP.Base = "weapon_base"

SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = false
SWEP.Weight = 1
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/niksacokica/datapad/datapad.mdl"
SWEP.UseHands = true

SWEP.HoldType = "slam"
SWEP.FiresUnderwater = true

SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = -1 
SWEP.Primary.Delay = 0
SWEP.Primary.DefaultClip = -1 
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = "none" 

SWEP.Secondary.ClipSize = -1 
SWEP.Secondary.DefaultClip = -1 
SWEP.Secondary.Damage = 0 
SWEP.Secondary.Automatic = false 	 
SWEP.Secondary.Ammo = "none"

SWEP.ViewModelBoneMods = {
	["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(10, 3, -1), angle = Angle(0, 0, 0) },
	["Slam_panel"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(10, 3, -1), angle = Angle(0, 0, 0) },
	["Detonator"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(10, 3, -1), angle = Angle(0, 0, 0) },
	
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, -10) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6, -20, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(40, -5, -40) },
	
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, -0.5), angle = Angle(0, 10, 30) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(-0.1, 0, 0), angle = Angle(-5, -30, 0) },
	["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(-0.1, 0, 0), angle = Angle(-5, -40, 10) },
	
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -44, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 20, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 30, 0) },
	
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -27, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 50, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 50, 0) },
	
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40, 0) },
	["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 80, 0) },
	
	["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 50, 0) },
	["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 80, 0) },
	
	
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-2, 0, 0), angle = Angle(5, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, -10, 10) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(30, -10, 0) }
}
	
SWEP.VElements = {
	["datapad"] = { model = "models/niksacokica/datapad/datapad.mdl", bone = "Slam_base", pos = Vector(2, -75, 14), angle = Angle(39, 13, 210), size = Vector(1.2, 1.2, 1.2) }
}

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:PrimaryAttack()
	if CLIENT then
		datapad:createScreen()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Holster(target)
	self:ResetBonePositions()
	
	return true
end

function SWEP:OnDrop()
	self:ResetBonePositions()
end

function SWEP:OwnerChanged()
	self:ResetBonePositions()
end

function SWEP:OnRemove()
	self:ResetBonePositions()
end

function SWEP:ViewModelDrawn( vm )
	self:UpdateBonePositions( vm )
	
	if self.VElements then
		self:CreateModels( self.VElements )

		for k, v in pairs( self.VElements ) do
			local model = v.curmodel
			if not v.bone then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			if not pos and not ang then continue end

			if IsValid( model ) then
				model:SetPos( pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis( ang:Up(), v.angle.y )
				ang:RotateAroundAxis( ang:Right(), v.angle.p )
				ang:RotateAroundAxis( ang:Forward(), v.angle.r )
				model:SetAngles( ang )

				if model:IsEffectActive( EF_BONEMERGE ) then
					model:RemoveEffects( EF_BONEMERGE )
					model:SetParent( nil )
				end

				model:DrawModel()
			end
		end
	end
end

function SWEP:UpdateBonePositions( vm )	
	if self.ViewModelBoneMods then
		for k, v in pairs( self.ViewModelBoneMods ) do
			local v = self.ViewModelBoneMods[k] or self:GetStat("ViewModelBoneMods." .. k)
			if not v then continue end

			local bone = vm:LookupBone(k)
			if not bone then continue end

			if vm:GetManipulateBoneScale(bone) ~= v.scale then
				vm:ManipulateBoneScale(bone, v.scale)
			end
			if vm:GetManipulateBoneAngles(bone) ~= v.angle then
				vm:ManipulateBoneAngles(bone, v.angle)
			end
			if vm:GetManipulateBonePosition(bone) ~= v.pos then
				vm:ManipulateBonePosition(bone, v.pos)
			end
		end
	end
end

function SWEP:ResetBonePositions()
	if not IsValid(self:GetOwner()) then return end
	
	local vm = self:GetOwner():GetViewModel()
	if not IsValid( vm ) then return end

	for i = 0, vm:GetBoneCount() do
		vm:ManipulateBoneScale(i, Vector(1, 1, 1))
		vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
		vm:ManipulateBonePosition(i, vector_origin)
	end
end

function SWEP:GetBoneOrientation( basetabl, tabl, ent )	
	local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
	
	if IsValid( ent ) then
		local bone = ent:LookupBone( tabl.bone ) or 0
		if not bone or bone == -1 then return end
		
		local m = ent:GetBoneMatrix(bone)
		if m then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
	end

	return pos, ang
end

function SWEP:CreateModels( tabl )
	for _, v in pairs(tabl) do
		if v.model and ( not IsValid( v.curmodel ) or v.curmodelname ~= v.model ) and v.model ~= "" then
			v.curmodel = ClientsideModel( v.model, RENDERGROUP_VIEWMODEL )

			if IsValid( v.curmodel ) then
				v.curmodel:SetPos(self:GetPos())
				v.curmodel:SetAngles(self:GetAngles())
				v.curmodel:SetParent(self)
				v.curmodel:SetOwner(self)
				v.curmodel:SetNoDraw(true)

				local matrix = Matrix()
				matrix:Scale(v.size)
				v.curmodel:EnableMatrix("RenderMultiply", matrix)
				v.curmodelname = v.model
			else
				v.curmodel = nil
			end
		end
	end
end