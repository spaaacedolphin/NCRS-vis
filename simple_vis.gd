extends Node3D

@export var scb_scene: PackedScene
const sizeof_double = 8
var celest_bodies = Array()
var file_pos: int
var play_speed = 0
var start_fpos: int
var delta_fpos : int
var end_fpos : int
var num_step : int
var cur_t : float
var barycenter : Vector3
var total_mass : float
var total_momentum : Vector3
var barycenter_vel : Vector3
var barycenter_point
var coordinate_offset : float
var retain : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file_pos = Global.f.get_position()
	start_fpos = file_pos
	delta_fpos = sizeof_double*3*Global.num_celest
	end_fpos = start_fpos + int(Global.max_t/Global.delta_t)*delta_fpos
	cur_t = 0.0
	num_step = (end_fpos-start_fpos)/delta_fpos
	retain = num_step
	
	total_mass = 0.0
	barycenter = Vector3(0,0,0)
	total_momentum = Vector3(0,0,0)
	var cur_mass = 0.0
	for i in Global.num_celest:
		cur_mass = Global.celest[i].mass
		total_mass += cur_mass
		barycenter += cur_mass * Global.celest[i].pos
		total_momentum += cur_mass * Global.celest[i].vel
	barycenter /= total_mass
	barycenter_vel = total_momentum/total_mass
	
	for i in Global.num_celest:
		celest_bodies.append(scb_scene.instantiate())
		celest_bodies[i].initialize(Global.celest[i].pos,Color.from_hsv(float(i)/float(Global.num_celest),0.75,0.97),retain)
		add_child(celest_bodies[i])
	
	barycenter_point = scb_scene.instantiate()
	barycenter_point.initialize(barycenter,Color("white"),retain)
	add_child(barycenter_point)

const MINUTE = 60.0
const HOUR = 60.0*MINUTE
const DAY = 24.0*HOUR
const YEAR = 365.25*DAY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	var year = int(cur_t/YEAR)
	var remainder = cur_t - YEAR*year
	var day = int(remainder/DAY)
	remainder -= DAY*day 
	var hour = int(remainder/HOUR)
	remainder -= HOUR*hour
	var minute = int(remainder/MINUTE)
	remainder -= MINUTE*minute
	var second = remainder
	var time_text = "t = "
	if year:
		time_text+="%dy" % year
	if day:
		time_text+="%4dd" % day
	if hour:
		time_text+="%3dh" % hour
	if minute:
		time_text+="%3dm" % minute
	if second:
		time_text+="%2.3fs" % second
	if time_text.length() == 4:
		time_text = "t = 0"
	$Control/CurTime.text = time_text
	$Control/CurTime/Timeline.value = cur_t/Global.max_t
	
	var cur_barycenter = barycenter+cur_t*barycenter_vel
	barycenter_point.move(cur_barycenter-coordinate_offset*cur_barycenter)
	
	Global.f.seek(file_pos)
	for i in Global.num_celest:
		var z = Global.f.get_double()
		var x = Global.f.get_double()
		var y = Global.f.get_double()
		#Global.celest[i].pos = Vector3(x,y,z)
		celest_bodies[i].move(Vector3(x,y,z)-coordinate_offset*cur_barycenter)
	
	var next_fpos = file_pos + play_speed*delta_fpos
	if next_fpos>=start_fpos and next_fpos<=end_fpos: 
		file_pos = next_fpos
	elif next_fpos<start_fpos:
		file_pos = start_fpos
	else:
		file_pos = end_fpos	
	
	cur_t = int((file_pos-start_fpos)/delta_fpos)*Global.delta_t
	

func _on_play_speed_slider_value_changed(value: float) -> void:
	play_speed = value
	$Control/PlaySpeedSlider/PlaySpeedLabel.text = "X%d" % play_speed


func _on_coordinate_toggle_toggled(toggled_on: bool) -> void:
	coordinate_offset = float(toggled_on)


func _on_retain_slider_value_changed(value: float) -> void:
	retain = int(value*num_step)
	#print(retain)
	#for i in Global.num_celest:
		#celest_bodies[i].initialize()
	#barycenter_point.initialize()
	
