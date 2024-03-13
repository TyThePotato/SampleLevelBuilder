class_name InputManager

static func get_movement_vector() -> Vector3:
	var vec = Vector3()
	
	# hate!!
	if Input.is_action_pressed("movement_left"): vec.x = -1
	if Input.is_action_pressed("movement_right"): vec.x = 1
	if Input.is_action_pressed("movement_down"): vec.y = -1
	if Input.is_action_pressed("movement_up"): vec.y = 1
	if Input.is_action_pressed("movement_forward"): vec.z = -1
	if Input.is_action_pressed("movement_backward"): vec.z = 1
	
	return vec.normalized()
	
static func get_camera_delta_vector() -> Vector2:
	var vel = Input.get_last_mouse_velocity()
	return vel
	
static func cursor_lock() -> bool:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return true
		
	return false
	
static func cursor_unlock() -> bool:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return true
		
	return false
