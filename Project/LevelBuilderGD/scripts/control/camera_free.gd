extends Node3D

@export var movement_speed = 4.0
@export var movement_boost_multiplier = 2.0
@export var look_speed = 0.01

var mouse_delta: Vector2
var cam_rot_x = 0.0
var cam_rot_y = 0.0

func _ready():
	Input.use_accumulated_input = false

func _process(delta: float):
	camera_movement(delta)
	
	if Input.is_action_pressed("camera_button"):
		if not InputManager.cursor_lock(): # don't process input immediately after locking cursor, otherwise view snaps
			camera_look(delta)
	else:
		InputManager.cursor_unlock()
		
	mouse_delta = Vector2.ZERO # reset
	
func _input(event):
	# get mouse input
	if event is InputEventMouseMotion:
		mouse_delta += event.relative
	
	
func camera_movement(delta: float):
	var move_vec = InputManager.get_movement_vector()
	
	var multi = 1.0
	if Input.is_action_pressed("movement_modifier_speed"):
		multi = movement_boost_multiplier
	
	translate_object_local(move_vec * movement_speed * multi * delta)
	
func camera_look(delta: float):
	# process input
	cam_rot_x -= mouse_delta.x * look_speed
	cam_rot_y -= mouse_delta.y * look_speed
	
	# restrict angles
	#cam_rot_x = fmod(cam_rot_x, 360)
	#cam_rot_y = clamp(cam_rot_y, -89, 89)
	
	# rotate camera
	transform.basis = Basis() # reset rotation
	rotate_object_local(Vector3.UP, cam_rot_x) # horizontal first
	rotate_object_local(Vector3.RIGHT, cam_rot_y) # then vertical
