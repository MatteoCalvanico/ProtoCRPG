extends CanvasLayer

# Action Points
@onready var APs = $Control/APContainer.get_children()

# Combat Buttons
@onready var attack_button = $Control/CombatContainer/CombatButtons/Attack
@onready var skip_button = $Control/CombatContainer/CombatButtons/Skip



func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_attack_pressed() -> void:
	print("Attack !!!")


func _on_skip_pressed() -> void:
	print("Round skipped...")
