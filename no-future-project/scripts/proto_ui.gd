extends CanvasLayer

# Control Pane
@onready var control = $Control

# Action Points
@onready var APs = $Control/APContainer.get_children()

# Combat Buttons
@onready var attack_button = $Control/CombatContainer/CombatButtons/Attack
@onready var skip_button = $Control/CombatContainer/CombatButtons/Skip



# Player enter in ATTACK MODE - Preventing clicks from passing through the GUI [Block movement]
func _on_attack_pressed() -> void:
	MessageBus.mouse_in_ui.emit()
	attack_button.disabled = true
	skip_button.disabled = false
	
	print("Attack !!!")


# Player exit from ATTACK MODE - Now is possible to move around - STOP preventing clicks from passing through the GUI
func _on_skip_pressed() -> void:
	MessageBus.mouse_out_ui.emit()
	attack_button.disabled = false
	skip_button.disabled = true
	
	print("Round skipped...")
