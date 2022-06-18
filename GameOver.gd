extends Panel


func _ready():
	# Unpauses the game upon startup, since this is the only file that runs even when the game is paused
	get_tree().paused = false
	
	# Creates the function _on_Button_up and connects button presses to it
	# The button text is added as an extra parameter
	$Button.connect("button_up", self, "_on_Button_up", [$Button.text])
	$Button2.connect("button_up", self, "_on_Button_up", [$Button2.text])

func _on_Button_up(button):
	match button:
		"Restart":
			var _reset = get_tree().reload_current_scene()
		
		# Closes the game
		"Quit":
			get_tree().quit()
