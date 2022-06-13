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
	if body.is_in_group("Enemies"):
		body.hp -= dmg
		print(body.hp)


func _on_Lifespan_timeout():
	queue_free()
