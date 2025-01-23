extends Node3D

var pressed = false
var rotate_vel = Vector2(0,0)
var roll_vel = 0
var UP_AXIS = Vector3(0,1,0)
var RIGHT_AXIS = Vector3(1,0,0)
var FRONT_AXIS = Vector3(0,0,1)

const AU = Global.AU
const C = Global.C
const KM = Global.KM

var move_speed = 0.1*AU
var move_dir = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func init_speed() -> void:
	$CameraInfo/CurPos.text = "%.3v %s" % [position/Global.pos_unit,Global.pos_unit_str]
	move_speed = position.y/2.5
	if move_speed>25*C:
		$CameraInfo/CurSpeed.text = "%.2f au/s" % (move_speed/AU)
	elif move_speed>=0.01*C:
		$CameraInfo/CurSpeed.text = "%.2f c" % (move_speed/C)
	elif move_speed>=KM:
		$CameraInfo/CurSpeed.text = "%.2f km/s" % (move_speed/KM)
	else:
		$CameraInfo/CurSpeed.text = "%.2f m/s" % move_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("roll_clockwise"):
		rotate_object_local(FRONT_AXIS,-0.01)
	elif Input.is_action_pressed("roll_anticlockwise"):
		rotate_object_local(FRONT_AXIS,0.01)
		
	move_dir = Vector3(0,0,0)
	if Input.is_action_pressed("move_forward"):
		move_dir -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		move_dir += transform.basis.z
	if Input.is_action_pressed("move_right"):
		move_dir += transform.basis.x
	elif Input.is_action_pressed("move_left"):
		move_dir -= transform.basis.x
	if Input.is_action_pressed("move_up"):
		move_dir += transform.basis.y
	elif Input.is_action_pressed("move_down"):
		move_dir -= transform.basis.y
		
	if move_dir.length()>0:
		move_dir = move_dir.normalized()
		position += move_speed * move_dir * delta
		$CameraInfo/CurPos.text = "%.3v %s" % [position/Global.pos_unit,Global.pos_unit_str]
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not pressed and event.pressed:
				pressed=true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				#print("pressed")
			if pressed and not event.pressed:
				pressed=false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				rotate_vel = Vector2(0,0)
				#print("unpressed")
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			move_speed*=1.1
			if move_speed>25*C:
				$CameraInfo/CurSpeed.text = "%.2f au/s" % (move_speed/AU)
			elif move_speed>=0.01*C:
				$CameraInfo/CurSpeed.text = "%.2f c" % (move_speed/C)
			elif move_speed>=KM:
				$CameraInfo/CurSpeed.text = "%.2f km/s" % (move_speed/KM)
			else:
				$CameraInfo/CurSpeed.text = "%.2f m/s" % move_speed
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			move_speed*=0.9
			if move_speed>25*C:
				$CameraInfo/CurSpeed.text = "%.2f au/s" % (move_speed/AU)
			elif move_speed>=0.01*C:
				$CameraInfo/CurSpeed.text = "%.2f c" % (move_speed/C)
			elif move_speed>=KM:
				$CameraInfo/CurSpeed.text = "%.2f km/s" % (move_speed/KM)
			else:
				$CameraInfo/CurSpeed.text = "%.2f m/s" % move_speed
			
	if event is InputEventMouseMotion and pressed:
		#print("moving")
		#print(event.relative)
		rotate_vel = event.relative * 0.005
		#print(rotate_vel)
		rotate_object_local(UP_AXIS,rotate_vel.x)
		rotate_object_local(RIGHT_AXIS,rotate_vel.y)
		#print(rotate_vel)
