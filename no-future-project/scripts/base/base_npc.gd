extends CharacterBody2D

@onready var click_area = $ClickArea
@onready var text_label = $TextLabel

# MAX distance from the NPC to be able to interact with it
@export var interaction_distance = 70.0 

# Player node in the scene
@export var player: CharacterBody2D = null


func _ready() -> void:
	# Set the "observer" - When the player click th NPC we do something
	click_area.connect("input_event", _npc_clicked)

# Called when the playr click on the click_area
func _npc_clicked(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("mouseDx"):
		var distance = global_position.distance_to(player.global_position) if player else 999.0
		if distance <= interaction_distance:
			_interact()
		else:
			print("You're too far away")

# Virtual function to be overriden by child classes
func _interact():
	pass
