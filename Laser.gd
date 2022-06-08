extends KinematicBody

# Variables are defined in spaceship.gd
var player
var spd
var dmg

func _ready():
	pass

func _physics_process(delta):
	var collision = move_and_collide(transform.basis.z * spd)
	if collision:
		queue_free()

func _on_Area_body_entered(body):
	pass # Replace with function body.


func _on_Lifespan_timeout():
	queue_free()
