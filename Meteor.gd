extends KinematicBody

var vel = Vector3.ZERO

var hp = 100

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	# Randomly selects one of two 3D models for the meteor instance
	var meteornumber = str(rng.randi_range(1, 2))
	$MeshInstance.mesh = load("res://Models/Meteor " + meteornumber + ".tres")
	
	# Randomly scales the meteor to a larger size
	var meteorscale = rng.randi_range(40, 50)
	$MeshInstance.scale = Vector3(1, 1, 1) * meteorscale
	
	# Loads in an instance of the collision box associated with the selected model
	$CollisionShape.shape = load("res://Models/CollisionShape Meteor " + meteornumber + ".tres").duplicate()
	
	# Scales the meteor to the randomized size
	for i in $CollisionShape.shape.points.size():
		$CollisionShape.shape.points[i] *= meteorscale
	


func _physics_process(delta):
	var collision = move_and_collide(vel * delta)
	
	# Deletes the meteor when health is below 0
	if hp <= 0:
		queue_free()
	
	# Checks for collisions, if the collider is the player, the meteor will be pushed in that direction
	if collision:
		var collider = collision.collider
		
		if collider.is_in_group("Player"):
			vel = collider.transform.basis.z * collider.currentspd / $CollisionShape.scale.x
			collider.currentspd = 0
