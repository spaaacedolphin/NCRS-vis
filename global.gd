extends Node

var current_scene = null

class Celestial:
	var name: String
	var mass: float
	var pos: Vector3
	var vel: Vector3
	
	func _init():
		self.name = ""
		self.mass = 0
		self.pos = Vector3(0,0,0)
		self.vel = Vector3(0,0,0)

var celest: Array

var f
var simulation_type: int
var num_celest: int
var max_t: float
var delta_t: float
var mass_default_unit: int
var pos_default_unit: int
var vel_default_unit: int
var cur_step : int

const AU: float = 149597870700
const C: float = 299792458
const KM: float = 1000
const pos_units = [1,KM,AU]
const pos_units_str = ["m","km","au"]
var pos_unit: float
var pos_unit_str: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
