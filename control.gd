extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$FileDialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	var f = FileAccess.open(path,FileAccess.READ)
	var simulation_type = f.get_8()
	var num_celest = f.get_32()
	var max_t = f.get_double()
	var delta_t = f.get_double()
	var mass_default_unit = f.get_8()
	var pos_default_unit = f.get_8()
	var vel_default_unit = f.get_8()
	
	var celest = Array()
	for i in num_celest:
		celest.append(Global.Celestial.new())
	
	for i in num_celest:
		var cur_celest_name = String()
		while true:
			var cur_ch = f.get_8()
			if cur_ch == 0:
				break
			cur_ch = String.chr(cur_ch)
			cur_celest_name += cur_ch
		celest[i].name = cur_celest_name
	
	for i in num_celest:
		celest[i].mass = f.get_double()
	
	for i in num_celest:
		celest[i].vel.z = f.get_double()
		celest[i].vel.x = f.get_double()
		celest[i].vel.y = f.get_double()
	
	for i in num_celest:
		celest[i].pos.z = f.get_double()
		celest[i].pos.x = f.get_double()
		celest[i].pos.y = f.get_double()
	
	
	var content_str = "Simulation_type: %d\n" % simulation_type
	content_str += "num_celest: %d\n" % num_celest
	content_str += "max_t: %.1f\tdelta_t: %.2f\n" %[max_t,delta_t]
	content_str += "default_units: %d %d %d\n" %[mass_default_unit,pos_default_unit,vel_default_unit]
	for i in num_celest:
		content_str += "------------------------------\n"
		content_str += "body_%d\n" % (i+1)
		content_str += "name: %s\n" % celest[i].name
		content_str += "mass: %f\n" % celest[i].mass
		content_str += "initial position: %v\n" % celest[i].pos
		content_str += "initial velocity: %v\n" % celest[i].vel
	
	$FileContentView.text = content_str
	
	Global.f = f
	Global.celest = celest
	Global.simulation_type = simulation_type
	Global.num_celest = num_celest
	Global.max_t = max_t
	Global.delta_t = delta_t
	Global.mass_default_unit = mass_default_unit
	Global.pos_default_unit = pos_default_unit
	Global.vel_default_unit = vel_default_unit
	
	Global.pos_unit = Global.pos_units[pos_default_unit]
	Global.pos_unit_str = Global.pos_units_str[pos_default_unit]
	
	$StartVis.disabled = false
	

func _on_start_vis_pressed() -> void:
	Global.goto_scene("res://simple_vis.tscn")
