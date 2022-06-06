extends KinematicBody

export var spd = 150
export var boost = 300
export var accel = 5

var currentspd = 0
var vel = Vector3.ZERO
export var sens = 0.1


func motion():
	var direction = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	
	rotate_object_local(Vector3(direction.y, 0, direction.x), 0.05)
	
	if Input.is_action_pressed("throttle"):
		if currentspd < boost:
			currentspd += accel
	else:
		if currentspd < spd:
			currentspd += accel
		elif currentspd > spd:
			currentspd -= accel
	
	if Input.is_action_pressed("brake"):
		currentspd -= accel * 2
	
	currentspd = clamp(currentspd, spd/2, boost)
	
	vel = transform.basis.z * currentspd
	
	transform = transform.orthonormalized()

# Called when the node enters the scene tree for the first time.
func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass


func _physics_process(delta):
	$Label.text = str(currentspd)
	
	motion()
	
	var collisions = move_and_collide(vel * delta)



func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE && !event.echo && event.pressed:
			if Input.get_mouse_mode() == 2:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.scancode == KEY_R:
			get_tree().reload_current_scene()
