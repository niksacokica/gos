AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()	
	self:SetModel( "models/niksacokica/sw_computer/sw_computer.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:DropToFloor()
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableMotion( false )
	end
end

function ENT:PhysicsCollide( data, physobj )
	if data.Speed > 60 and data.DeltaTime > 0.2 then
		self:EmitSound( "SolidMetal.ImpactSoft" )
	end
end

function ENT:Use( activator )
	if activator:IsPlayer() then
		net.Start( "datapad_open" )
		net.Send( activator )
	end
end