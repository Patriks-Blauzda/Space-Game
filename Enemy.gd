extends KinematicBody

export var hp = 75
export var spd = 15
export var laserspd = 30
export var laserdmg = 5

var laser = load("res://Laser.tscn")


# spawns an instance of a laser projectile
func shoot_laser():
	if $Weapons/LaserCooldown.is_stopped():
		# saves the instanced laser beam in a variable
		var laserinst = laser.instance()
		
		# values are assigned before the laser beam is created
		laserinst.spd = -laserspd
		laserinst.dmg = laserdmg
		
		# sets the projectile's position to be in front of the player
		laserinst.transform = self.transform
		laserinst.translate_object_local($Weapons/LaserPosition.translation)
		
		laserinst.get_node("Area").set_collision_mask_bit(0, true)
		laserinst.get_node("Area").set_collision_mask_bit(1, false)
		
		# spawns the projectile in the parent node and starts a timer
		# another laser cannot be fired until the timer stops
		get_parent().add_child(laserinst)
		$Weapons/LaserCooldown.start()


func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("Player")[0]
	
	var direction = global_transform.looking_at(player.global_transform.origin, Vector3(0,1,0))
	
	global_transform.basis.y = lerp(global_transform.basis.y, direction.basis.y, delta)
	global_transform.basis.x = lerp(global_transform.basis.x, direction.basis.x, delta)
	global_transform.basis.z = lerp(global_transform.basis.z, direction.basis.z, delta)
	
	if $ShootArea.overlaps_body(player):
		shoot_laser()
	
	move_and_slide(transform.basis.z * -spd)
	
	if hp <= 0:
		queue_free()
