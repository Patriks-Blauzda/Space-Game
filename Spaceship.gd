extends KinematicBody

# normal movement speed, boost speed and acceleration
export var spd = 150
export var boost = 300
export var accel = 5
export var rotationspd = 0.05


var currentrotation = rotationspd
var saveddirections = Vector2.ZERO
var currentspd = 0
# to be used for the 3d matrix and multiplied by current speed
var vel = Vector3.ZERO

var rng = RandomNumberGenerator.new()

# handles player movement and rotation
func motion():
	# takes joystick or arrow key input and turns it into a 2d vector
	var direction = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	
	# if player is turning, increment current rotation speed by a fraction of max rotation speed
	# if player isn't turning, decrement it by the same amount
	# used for smoothing the player's turning
	if direction.x != 0 || direction.y != 0:
		currentrotation = clamp(currentrotation + rotationspd * 0.1, 0, rotationspd)
		# saves directional inputs for a smooth stop when letting go of movement buttons
		saveddirections = direction
	else:
		currentrotation = clamp(currentrotation - rotationspd * 0.1, 0, rotationspd)
	
	
	# function rotates the player by specified angle (0.05 radians)
	rotate_object_local(Vector3(saveddirections.y, 0, saveddirections.x).normalized(), currentrotation)
	
	
	# if button is held, max speed is increased
	if Input.is_action_pressed("throttle"):
		if currentspd < boost:
			currentspd += accel
	else:
		if currentspd < spd:
			currentspd += accel
		elif currentspd > spd:
			currentspd -= accel
	
	# slows the player
	if Input.is_action_pressed("brake"):
		currentspd -= accel * 2
	
	# keeps speed above normal speed divided by 2, and below boost speed
	currentspd = clamp(currentspd, spd/2, boost)
	
	# gets local Z axis (forward/backward) and multiplies it by the current speed
	vel = transform.basis.z * currentspd
	
	# function returns a normalized and orthogonal 3d matrix
	# used for preventing issues with rotation
	transform = transform.orthonormalized()


# Called when the node enters the scene tree for the first time.
func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rng.randomize()


func _physics_process(delta):
	# used to display speed on the screen
	$Label.text = str(currentspd) + "\n"
	
	motion()
	
	# camera shakes when going above normal speed
	if currentspd > spd:
		$Camera.h_offset = rng.randf_range(-currentspd*0.0001, currentspd*0.0001)
		$Camera.v_offset = rng.randf_range(-currentspd*0.0001, currentspd*0.0001)
	else:
		$Camera.h_offset = 0
		$Camera.v_offset = 0
	
	# calculates collision and movement
	var collisions = move_and_collide(vel * delta)


# checks if ESC or R are pressed, esc toggles mouse mode and R reloads the game
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE && !event.echo && event.pressed:
			if Input.get_mouse_mode() == 2:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.scancode == KEY_R:
			get_tree().reload_current_scene()
