extends KinematicBody

# Variables are defined in spaceship.gd
var spd
var dmg

# Moves the laser forward
func _physics_process(_delta):
	var _collision = move_and_collide(transform.basis.z * spd)

# If the laser is colliding with an enemy, it removes health equal to the laser's damage, then deletes self
func _on_Area_body_entered(body):
	if body.is_in_group("Enemies"):
		body.hp -= dmg
	elif body.is_in_group("Player"):
		body.player.hp -= dmg
	queue_free()

# Deletes the laser after a specific amount of time
func _on_Lifespan_timeout():
	queue_free()
