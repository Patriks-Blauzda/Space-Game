extends KinematicBody

var vel = Vector3.ZERO

var hp = 100

var rng = RandomNumberGenerator.new()

var debris = load("res://MeteorDebris.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	# Randomly selects one of two 3D models for the meteor instance
	var meteornumber = str(rng.randi_range(1, 2))
	$MeshInstance.mesh = load("res://Models/Meteor " + meteornumber + ".tres")
	
	# Randomly scales the meteor to a larger size
	var meteorscale = rng.randi_range(20, 50)
	$MeshInstance.scale = Vector3(1, 1, 1) * meteorscale
	
	# Loads in an instance of the collision box associated with the selected model
	$CollisionShape.shape = load("res://Models/CollisionShape Meteor " + meteornumber + ".tres").duplicate()
	
	# Randomizes meteor rotation on creation
	rotation_degrees = Vector3(
		rng.randi_range(0, 360),
		rng.randi_range(0, 360),
		rng.randi_range(0, 360)
	)
	
	# Scales the meteor to the randomized size
	for i in $CollisionShape.shape.points.size():
		$CollisionShape.shape.points[i] *= meteorscale
	


func _physics_process(delta):
	var collision = move_and_collide(vel * delta)
	
	# Deletes the meteor when health is below 0 and instances particles
	if hp <= 0:
		var debrisinst = debris.instance()
		debrisinst.translation = self.translation
		debrisinst.scale = $MeshInstance.scale / 2
		get_parent().add_child(debrisinst)
		queue_free()
	
	# Checks for collisions, if the collider is the player, the meteor will be pushed in that direction
	if collision:
		var collider = collision.collider
		
		if collider.is_in_group("Player"):
			vel = collider.transform.basis.z * collider.player.currentspd / ($CollisionShape.scale.x * 2.5)
			collider.player.currentspd = 0
		
		elif collider is KinematicBody:
			collider.vel += vel / ($CollisionShape.scale.x * 2.5)
			self.vel /= 2
