extends "base/base_npc.gd"

var _response = ["Hi, I'm a ProtoNPC", "Welcome to the ProtoWorld", "Hello there"]

# Overriden function from base class
func _interact():
	_text_timer.stop() # Stop pasrevius waiting time
	MessageBus.log.emit("NPC 1 clicked")
	
	# Pick a random response
	_text_label.text = _response.pick_random()
	
	# Wait 3 sec then hide the text
	_text_timer.start(3.0) 
