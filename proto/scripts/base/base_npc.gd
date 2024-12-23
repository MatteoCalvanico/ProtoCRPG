extends CharacterBody2D
## Base class for all NPCs
##
## This class export two major variables:
##  - [param interaction_distance]
##  - [param player]
## and one virtual major method:
##  - [method Class._interact]
##
## Usage:
## [codeblock]
## extends "base/base_npc.gd"
## ...
## func _interact():
##     something
## [/codeblock]

@onready var _click_area = $ClickArea
@onready var _text_label = $TextLabel
@onready var _text_timer = $TextTimer

@export var interaction_distance = 70.0 ## MAX distance from the NPC to be able to interact with it

@export var player: CharacterBody2D = null ## Player node in the scene


func _ready() -> void:
	# Set the "observer" - When the player click th NPC we do something
	_click_area.connect("input_event", _npc_clicked)

# Called when the playr click on the _click_area
func _npc_clicked(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("mouseDx"):
		var distance = global_position.distance_to(player.global_position) if player else 999.0
		if distance <= interaction_distance:
			_interact()
		else:
			MessageBus.log.emit("I'm too far away")

## Virtual function to be overriden by child classes
func _interact():
	pass

# Hide text after timer expires
func _on_text_timer_timeout() -> void:
	_text_label.text = ""
