extends CanvasLayer

# Control Pane
@onready var control = $Control

# Action Points
@onready var APs = $Control/APContainer.get_children()

# Combat Buttons
@onready var attack_button = $Control/CombatContainer/CombatButtons/Attack
@onready var skip_button = $Control/CombatContainer/CombatButtons/Skip

var ap_count = 0
const AP_EMPTY = Color(50, 50, 50, 1)
const AP_FILL = Color(0, 0, 255,1)


func _ready() -> void:
	MessageBus.ap_remove.connect(ap_update)
	MessageBus.ap_restore.connect(ap_reset)

# Player enter in ATTACK MODE
func _on_attack_pressed() -> void:
	MessageBus.attack_mode_on.emit()
	attack_button.disabled = true
	skip_button.disabled = false
	
	print("Attack !!!")

# Player exit from ATTACK MODE - Now is possible to move around - APs restored
func _on_skip_pressed() -> void:
	MessageBus.attack_mode_off.emit()
	MessageBus.ap_restore.emit(0)
	attack_button.disabled = false
	skip_button.disabled = true
	
	print("Round skipped...")

## MessageBus related function
func ap_update(count: int):
	ap_count += 1
	print(ap_count)
	if ap_count % 32 == 0:
		print("Enter IF")
		for AP in APs:
			print(AP)
			if AP.get_color() == AP_FILL:
				AP.set_color(AP_EMPTY)
				break

func ap_reset(count: int):
	ap_count = 0
	for AP in APs:
		AP.set_color(AP_FILL)
