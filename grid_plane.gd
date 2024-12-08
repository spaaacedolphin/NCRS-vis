extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector3(0,0,0);

var cam_pos : Vector3;
var ratio : float;
const AU = 149597870700
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	cam_pos = get_node("../free_view").position;
	ratio = cam_pos.length()/1000.0;
	scale = Vector3(ratio,(cam_pos.y/abs(cam_pos.y))*ratio,ratio);
	$GridUnitLen.text="grid unit : %.3f au" % (ratio*10000*0.04/AU)
