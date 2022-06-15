extends KinematicBody

class spaceship:
	# Normal movement speed, boost speed and acceleration
	var spd = 40
	var boost = 80
	var accel = 1
	var rotationspd = 1
	
	var currentrotation = 0
	var saveddirections = Vector2(0, 1)
	var currentspd = 0
	
	# To be used for the 3d matrix and multiplied by current speed
	var vel = Vector3.ZERO
	
	# Values to be assigned to laser.gd on instance creation
	var laserspd = 30
	var laserdmg = 15
	
	# Loads the scene containing the laser projectile

onready var laser = load("res://Laser.tscn")


var player = spaceship.new()

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# handles player movement and rotation
func motion():
	# takes joystick or arrow key input and turns it into a 2d vector
	var direction = Input.get_vector("joystick_left", "joystick_right", "joystick_down", "joystick_up")
	
	# if player is turning, increment current rotation speed by a fraction of max rotation speed
	# if player isn't turning, decrement it by the same amount
	# used for smoothing the player's turning
	if direction.x != 0 || direction.y != 0:
		player.currentrotation = clamp(player.currentrotation + player.rotationspd * 0.1, 0, player.rotationspd)
		# saves directional inputs for a smooth stop when letting go of movement buttons
		player.saveddirections = direction.normalized()
	else:
		player.currentrotation = clamp(player.currentrotation - player.rotationspd * 0.1, 0, player.rotationspd)
	
	# function rotates the player by specified angle (0.05 radians)
	rotate_object_local(Vector3(player.saveddirections.y, 0, player.saveddirections.x).normalized(),
								clamp(player.currentrotation / (player.currentspd + 1), 0, 0.05))
	
	
	# if button is held, max speed is increased
	if Input.is_action_pressed("throttle") && $Boost/BoostMeter.value > 0:
		if player.currentspd < player.boost:
			player.currentspd += player.accel
			
		# If BoostMeter's value is 0, the player can't use the boost
		# BoostMeter recharges after 2 seconds of it not being used
		
		# Boost is only drained when the player moves above normal speed
		if player.currentspd > player.spd:
			$Boost/BoostMeter.value -= 1
			
		$Boost/BoostCooldown.start()
	else:
		if player.currentspd < player.spd:
			player.currentspd += player.accel
		elif player.currentspd > player.spd:
			player.currentspd -= player.accel
	
	# Recharges the player's boost when the cooldown is over
	if $Boost/BoostCooldown.is_stopped():
		$Boost/BoostMeter.value += 1
	
	# slows the player
	if Input.is_action_pressed("brake"):
		player.currentspd -= player.accel * 2
	
	# keeps speed above normal speed divided by 2, and below boost speed
	player.currentspd = clamp(player.currentspd, 0, player.boost)
	
	# gets local Z axis (forward/backward) and multiplies it by the current speed
	player.vel = transform.basis.z * player.currentspd
	
	# function returns a normalized and orthogonal 3d matrix
	# used for preventing issues with rotation
	transform = transform.orthonormalized()


# spawns an instance of a laser projectile
func shoot_laser():
	if Input.is_action_pressed("Laser") && $Weapons/LaserCooldown.is_stopped():
		# saves the instanced laser beam in a variable
		var laserinst = laser.instance()
		
		# values are assigned before the laser beam is created
		laserinst.player = self
		
		laserinst.spd = player.laserspd
		laserinst.dmg = player.laserdmg
		
		# sets the projectile's position to be in front of the player
		laserinst.transform = self.transform
		laserinst.translate_object_local($Weapons/LaserPosition.translation)
		
		# spawns the projectile in the parent node and starts a timer
		# another laser cannot be fired until the timer stops
		get_parent().add_child(laserinst)
		$Weapons/LaserCooldown.start()

func _physics_process(delta):
	# used to display speed on the screen
	$Label.text = str(player.currentspd) + "\n"
	
	motion()
	
	shoot_laser()
	
	# camera shakes when going above normal speed
	if player.currentspd > player.spd:
		$Camera.h_offset = rng.randf_range(-player.currentspd*0.0001, player.currentspd*0.0001)
		$Camera.v_offset = rng.randf_range(-player.currentspd*0.0001, player.currentspd*0.0001)
	else:
		$Camera.h_offset = 0
		$Camera.v_offset = 0
	
	# calculates collision and movement
	var collision = move_and_collide(player.vel * delta)
	
	# stops the player when colliding with an object
	if collision:
		if collision.collider is StaticBody:
			player.currentspd = 0


# checks if ESC or R are pressed, esc toggles mouse mode and R reloads the game
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE && !event.echo && event.pressed:
			if Input.get_mouse_mode() == 2:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.scancode == KEY_R && !event.echo && event.pressed:
			get_tree().reload_current_scene()
