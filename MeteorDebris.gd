extends Particles

# Begins emitting particles
# The particle emitter is set to only do this once
func _ready():
	emitting = true

# When finished emitting, deletes self
func _process(_delta):
	if !emitting:
		queue_free()
