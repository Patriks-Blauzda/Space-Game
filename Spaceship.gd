extends KinematicBody

var spd = 500
var vel = Vector3.ZERO
export var sens = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var velocity = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	rotation_degrees.y -= velocity.x
	rotation_degrees.x += velocity.y
	
	if Input.is_action_pressed("throttle"):
		vel += transform.basis.z
		if vel.distance_to(translation) > spd * 4:
			vel -= transform.basis.z
	
	if Input.is_action_pressed("brake"):
		vel *= 0.95
	
	var collisions = move_and_collide(vel * delta)
	
	if collisions:
		vel *= 0.65


func _input(event):
	if event is InputEventMouseMotion:
		
		rotation_degrees += Vector3(event.relative.y * sens, -event.relative.x * sens, 0)
	
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE && !event.echo && event.pressed:
			if Input.get_mouse_mode() == 2:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.scancode == KEY_R:
			get_tree().reload_current_scene()
