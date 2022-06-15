extends Spatial

var rng = RandomNumberGenerator.new()

var meteor = load("res://Meteor.tscn")

func _ready():
	rng.randomize()
	
	
	# Places an intanced meteor in specified areas, excluding player spawn point
	for _i in range(rng.randi_range(20, 40)):
		var meteorinst = meteor.instance()
		
		meteorinst.translation = Vector3(
		rng.randi_range(300, 750) * (rng.randi_range(0, 1) * 2 - 1),
		rng.randi_range(300, 750) * (rng.randi_range(0, 1) * 2 - 1),
		rng.randi_range(300, 750) * (rng.randi_range(0, 1) * 2 - 1)
		)
		
		$Meteors.add_child(meteorinst)
