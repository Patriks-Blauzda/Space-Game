extends Spatial

var rng = RandomNumberGenerator.new()

var meteor = load("res://Meteor.tscn")
var enemy = load("res://Enemy.tscn")

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


# Spawns between 1 and 4 enemies far from the spawn point in a set interval
# Default: every 10 seconds
func _on_EnemySpawnTimer_timeout():
	for _i in range(rng.randi_range(1, 4)):
		var enemyinst = enemy.instance()
		
		enemyinst.translation = Vector3(
		rng.randi_range(600, 900) * (rng.randi_range(0, 1) * 2 - 1),
		rng.randi_range(600, 900) * (rng.randi_range(0, 1) * 2 - 1),
		rng.randi_range(600, 900) * (rng.randi_range(0, 1) * 2 - 1)
		)
		
		$Enemies.add_child(enemyinst)
