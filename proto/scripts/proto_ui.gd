extends Control


# Display for info
@onready var display = $InfoDisplay

# Action Points
@onready var APs = $APContainer.get_children()

# Combat Buttons
@onready var attack_button = $CombatContainer/CombatButtons/Attack
@onready var skip_button = $CombatContainer/CombatButtons/Skip

var ap_count = 0
const AP_EMPTY = Color(50, 50, 50, 1)
const AP_FILL = Color(0, 0, 255,1)


func _ready() -> void:
	MessageBus.ap_remove.connect(_ap_update)
	MessageBus.ap_restore.connect(_ap_reset)
	
	MessageBus.log.connect(_write)
	
	_ap_reset(9)
	
	display.mouse_filter = MOUSE_FILTER_IGNORE # Block scroll with mouse wheel 

# Player enter in ATTACK MODE
func _on_attack_pressed() -> void:
	MessageBus.attack_mode_on.emit()
	attack_button.disabled = true
	skip_button.disabled = false
	
	MessageBus.log.emit("Entering attack mode...")

# Player exit from ATTACK MODE - Now is possible to move around - APs restored
func _on_skip_pressed() -> void:
	MessageBus.attack_mode_off.emit()
	MessageBus.ap_restore.emit(9)
	attack_button.disabled = false
	skip_button.disabled = true
	
	MessageBus.log.emit("Round skipped")
	MessageBus.log.emit("Coming out of attack mode...") # This will be written if you press Skip and there are no other enemies to attack

## MessageBus related function
func _ap_update(count: int):
	ap_count += 1
	if ap_count % 32 == 0:
		for AP in APs:
			if AP.get_color() == AP_FILL:
				AP.set_color(AP_EMPTY)
				break

func _ap_reset(count: int):
	for AP in APs:
		if count == 0:
			break
		count -= 1
		AP.set_color(AP_FILL)

func _write(log: String):
	display.text = display.text + "\n - " + log
