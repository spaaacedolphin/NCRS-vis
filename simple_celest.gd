extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func initialize(init_pos: Vector3, color: Color, retain: int):
	position = init_pos
	$Celest.mesh.material.emission = color
	$Trail.material.emission = color
	$Trail.lifetime=retain
	
func move(pos: Vector3):
	position = pos
	$Trail.update(1)
