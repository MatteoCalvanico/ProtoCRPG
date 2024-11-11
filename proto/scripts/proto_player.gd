extends CharacterBody2D

## !!! Player STATS !!!
# All this thing will be placed in a Singleton class or database
const SPEED = 200
const AP = 9 * 32 # 32 is the tile size

var isMoving: bool = false # Needed to make possible the movement with only one click
var attack_mode = false
var target = null
var used_ap = 0

@onready var navigator = $NavigationAgent2D
@onready var camera = $Camera2D

@onready var layer0 = $"../Layer0"


func _ready() -> void:
	MessageBus.attack_mode_on.connect(update)
	MessageBus.attack_mode_off.connect(reset)

func _physics_process(delta: float) -> void:
	# Player movement
	if isMoving && target != null:
		_move(target)
	elif OS.is_debug_build():
			# Move with WASD and Arrows [ONLY DEBUG MODE]
			var direction = Input.get_vector("left", "right", "down", "up")
			if direction:
				self.velocity = direction * SPEED
			else :
				self.velocity = Vector2.ZERO
			move_and_slide()


# Prevents clicks from passing through the GUI - If the player clicks in the GUI area we don't move  
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		#Move with Mouse [One click]
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Only update the target location if navigator is finiashed OR player wants to change location
			if !isMoving || event.button_index == MOUSE_BUTTON_LEFT:
				# Move to position only if in navigation area
				if _is_mouse_position_valid():
					target = self.get_global_mouse_position()
					isMoving = true
					
					var log = "Moving to: " + str(layer0.local_to_map(layer0.get_local_mouse_position()))
					MessageBus.log.emit(log)
					
				## This use Layout0 coords, but when is use it in move doesn't take the right cell
				## This logic can be used to highlight the cell clicked by the user
				##print(layer0.local_to_map(layer0.get_local_mouse_position()))
				##layer0.set_cell(layer0.local_to_map(layer0.get_local_mouse_position()), 0, Vector2i(0,0))
				
		# Camera Zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN && camera.zoom >= Vector2(0.5,0.5):
			camera.zoom *= 0.9
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP && camera.zoom <= Vector2(2,2):
			camera.zoom *= 1.1


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity

# Move the player to the target position
## NEED FIX - Sometimes player get stuck and ap continue to decrese
func _move(target_position: Vector2):
	navigator.target_position = target_position
	
	# NavigationAgent has reached the target location
	if navigator.is_navigation_finished():
		isMoving = false
		return
		
	if attack_mode:
		used_ap += 1
		MessageBus.ap_remove.emit(1)
	
	# Update NavigationAgent
	if used_ap <= AP:
		var current_navigator_position = self.global_position
		var next_path_position = navigator.get_next_path_position()
		var new_velocity = current_navigator_position.direction_to(next_path_position) * SPEED
	
		# Our navigator is set to avoid obstacle
		if navigator.avoidance_enabled:
			navigator.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)
	
		move_and_slide()
	else: 
		MessageBus.log.emit("APs are finished")
		target = self.global_position

# Check if the mouse position is in navigation area (no boundaries)
func _is_mouse_position_valid():
	# First check: mouse position in the map boundaries
	if layer0.local_to_map(layer0.get_local_mouse_position()) in layer0.get_used_cells():
		# Second check: mouse position isn't in the boundaries - Redundant, boundaries are not navigable
		if layer0.get_cell_atlas_coords(layer0.local_to_map(layer0.get_local_mouse_position())) != Vector2i(0,1):
			return true
	else:
		MessageBus.log.emit("I cannot reach that postion...")
		return false

## MessageBus related function
func update():
	used_ap = 0
	attack_mode = true
	target = self.global_position # Remove previus target

func reset():
	used_ap = 0
	attack_mode = false
	target = self.global_position # Remove previus target
