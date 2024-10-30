extends "base/base_npc.gd"

# Overriden function from base class
func _interact():
	print("NPC clicked")
	
	text_label.text = "Hi, I'm another ProtoNPC"
	await get_tree().create_timer(3).timeout # Wait 3 sec then hide the text
	text_label.text = ""
