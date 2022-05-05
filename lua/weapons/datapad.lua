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
SWEP.ViewModelFOV = 100
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

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:PrimaryAttack()
end
	
function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:ViewModelDrawn( vm )
	self.VElements = {
		["element_name"] = { type = "Model", model = "models/niksacokica/datapad/datapad.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(2, 1, 3), angle = Angle(90, 180, 90), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	if self.VElements then
		self:CreateModels(self.VElements, true)

		self.SCKMaterialCached_V = self.SCKMaterialCached_V or {}

		if (not self.vRenderOrder) then
			-- // we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs(self.VElements) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				end
			end
		end

		for _, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]

			if (not v) then
				self.vRenderOrder = nil
				break
			end

			if (v.hide) then continue end
			local model = v.curmodel
			local sprite = v.spritemat
			if (not v.bone) then continue end
			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
			if not pos and not v.bonemerge then continue end

			if (v.type == "Model" and IsValid(model)) then
				if not v.bonemerge then
					model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
					model:SetAngles(ang)
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				if v.bonemerge then
					if v.rel and self.VElements[v.rel] and IsValid(self.VElements[v.rel].curmodel) then
						v.parModel = self.VElements[v.rel].curmodel
					else
						v.parModel = self.OwnerViewModel or self
					end
					if model:GetParent() ~= v.parModel then
						model:SetParent(v.parModel)
					end

					if not model:IsEffectActive(EF_BONEMERGE) then
						model:AddEffects(EF_BONEMERGE)
						model:AddEffects(EF_BONEMERGE_FASTCULL)
						model:SetMoveType(MOVETYPE_NONE)
						model:SetLocalPos(vector_origin)
						model:SetLocalAngles(angle_zero)
					end
				elseif model:IsEffectActive(EF_BONEMERGE) then
					model:RemoveEffects(EF_BONEMERGE)
					model:SetParent(nil)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			end
		end
	end
	
	--vm:SetModel("models/niksacokica/datapad/datapad.mdl")
	--local scale = Vector(0.44, 0.44, 0.44)

	--local mat = Matrix()
	--mat:Scale(scale)
	--vm:EnableMatrix("RenderMultiply", mat)
end

function SWEP:GetBoneOrientation(basetabl, tabl, ent, bone_override)
	local bone, pos, ang
	if not IsValid(ent) then return Vector(0, 0, 0), Angle(0, 0, 0) end

	if tabl.rel and tabl.rel ~= "" and not tabl.bonemerge then
		local v = basetabl[tabl.rel]
		if (not v) then return end
		local boneName = bone_override or tabl.bone

		if v.curmodel and ent ~= v.curmodel and (v.bonemerge or (boneName and boneName ~= "" and v.curmodel:LookupBone(boneName))) then
			v.curmodel:SetupBones()
			pos, ang = self:GetBoneOrientation(basetabl, v, v.curmodel, boneName)
			if pos and ang then return pos, ang end
		else
			--As clavus states in his original code, don't make your elements named the same as a bone, because recursion.
			pos, ang = self:GetBoneOrientation(basetabl, v, ent)

			if pos and ang then
				pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				-- For mirrored viewmodels.  You might think to scale negatively on X, but this isn't the case.

				return pos, ang
			end
		end
	end

	if isnumber(bone_override) then
		bone = bone_override
	else
		bone = ent:LookupBone(bone_override or tabl.bone) or 0
	end

	if (not bone) or (bone == -1) then return end
	pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
	local m = ent:GetBoneMatrix(bone)

	if (m) then
		pos, ang = m:GetTranslation(), m:GetAngles()
	end

	if (IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and ent == self:GetOwner():GetViewModel() and self.ViewModelFlip) then
		ang.r = -ang.r
	end

	return pos, ang
end

function SWEP:CreateModels(tabl, is_vm)
	if (not tabl) then return end

	for _, v in pairs(tabl) do
		if (v.type == "Model" and v.model and (not IsValid(v.curmodel) or v.curmodelname ~= v.model) and v.model ~= "") then
			v.curmodel = ClientsideModel(v.model, RENDERGROUP_VIEWMODEL)
			TFA.RegisterClientsideModel(v.curmodel, self)

			if (IsValid(v.curmodel)) then
				v.curmodel:SetPos(self:GetPos())
				v.curmodel:SetAngles(self:GetAngles())
				v.curmodel:SetParent(self)
				v.curmodel:SetOwner(self)
				v.curmodel:SetNoDraw(true)

				if v.material then
					v.curmodel:SetMaterial(v.material or "")
				end

				if v.skin then
					v.curmodel:SetSkin(v.skin)
				end

				local matrix = Matrix()
				matrix:Scale(v.size)
				v.curmodel:EnableMatrix("RenderMultiply", matrix)
				v.curmodelname = v.model

				if is_vm then
					v.view = true
				else
					v.view = false
				end
			else
				v.curmodel = nil
			end
			-- // make sure we create a unique name based on the selected options
		end
	end
end