extends "base/base_npc.gd"

var response = ["Hi, I'm a ProtoNPC", "Welcome to the ProtoWorld", "Hello there"]

# Overriden function from base class
func _interact():
	text_timer.stop() # Stop previus waiting time
	print("NPC clicked")
	
	# Pick a random response
	text_label.text = response.pick_random()
	
	# Wait 3 sec then hide the text
	text_timer.start(3.0) 
