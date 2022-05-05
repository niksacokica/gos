$ModelName "niksacokica/datapad.mdl"

$BodyGroup "body"
{
	studio "sw_datapad_reference.smd"
}


$SurfaceProp "metal"

$Contents "solid"

$MaxEyeDeflection 90

$MostlyOpaque

$CDMaterials "niksacokica\datapad\"

$CBox 0 0 0 0 0 0

$Sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 1
	loop
}

$CollisionModel "sw_datapad_physics.smd"
{
	$automass
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}