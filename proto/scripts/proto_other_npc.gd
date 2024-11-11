extends "base/base_npc.gd"

var _response = ["Hi, I'm another ProtoNPC", "Welcome to the ProtoWorld", "Hi"]

# Overriden function from base class
func _interact():
	_text_timer.stop() # Stop previus waiting time
	MessageBus.log.emit("NPC 2 clicked")
	
	# Pick a random response
	_text_label.text = _response.pick_random()
	
	# Wait 3 sec then hide the text
	_text_timer.start(3.0) 
