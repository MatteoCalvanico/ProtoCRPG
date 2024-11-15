extends CharacterBody2D

## !!! Player STATS !!!
# All this thing will be placed in a Singleton class or database
const SPEED = 200
const AP = 9 * 32 # 32 is the tile size
var _health = 50.0

## !!! Utils !!!
var _isMoving: bool = false # Needed to make possible the movement with only one click
var _attack_mode = false
var _target = null
var _used_ap = 0
#var nav_layer_value # Represents the values associated with the Navigation Layer, we take it from a cells that have it - # No needed in this implementation
var border_value = Vector2i(0,1) # Rapresents the border in the TileSet

## !!! Scenes nodes !!!
@onready var _navigator = $NavigationAgent2D
@onready var _camera = $Camera2D

@onready var _layer0 = $"../Layer0"
@onready var _layer1 = $"../Layer1"

func _ready() -> void:
	MessageBus.attack_mode_on.connect(_update)
	MessageBus.attack_mode_off.connect(_reset)
	
	MessageBus.health_change.connect(_change_health)
	
	# No needed in this implementation
	#nav_layer_value = [_layer0.get_cell_tile_data(Vector2i(5,0)).get_navigation_polygon(0), _layer0.get_cell_tile_data(Vector2i(3,0)).get_navigation_polygon(0), _layer0.get_cell_tile_data(Vector2i(0,0)).get_navigation_polygon(0)]

func _physics_process(delta: float) -> void:
	# Player movement
	if _isMoving && _target != null:
		_move(_target)
	elif OS.is_debug_build():
			# Move with WASD and Arrows [ONLY DEBUG MODE]
			var direction = Input.get_vector("left", "right", "down", "up")
			if direction:
				self.velocity = direction * SPEED
			else :
				self.velocity = Vector2.ZERO
			move_and_slide()
	
	# Player heal
	if Input.is_action_just_pressed("heal"):
		MessageBus.health_change.emit(100)


# Prevents clicks from passing through the GUI - If the player clicks in the GUI area we don't move  
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		#Move with Mouse [One click]
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Only update the target location if navigator is finiashed OR player wants to change location
			if !_isMoving || event.button_index == MOUSE_BUTTON_LEFT:
				# Move to position only if in navigation area
				if _is_mouse_position_valid():
					_target = self.get_global_mouse_position()
					_isMoving = true
					
					var log = "Moving to: " + str(_layer0.local_to_map(_layer0.get_local_mouse_position()))
					MessageBus.log.emit(log)
					
				## This use Layout0 coords, but when is use it in move doesn't take the right cell
				## This logic can be used to highlight the cell clicked by the user
				##print(layer0.local_to_map(layer0.get_local_mouse_position()))
				##layer0.set_cell(layer0.local_to_map(layer0.get_local_mouse_position()), 0, Vector2i(0,0))
				
		# Camera Zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN && _camera.zoom >= Vector2(0.5,0.5):
			_camera.zoom *= 0.9
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP && _camera.zoom <= Vector2(2,2):
			_camera.zoom *= 1.1


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity

# Check if the mouse position is in navigation area (no boundaries or obstacles)
func _is_mouse_position_valid():
	var mouse_pos = _layer0.local_to_map(_layer0.get_local_mouse_position())
	var mouse_pos_layer1 = _layer1.local_to_map(_layer1.get_local_mouse_position()) - Vector2i(1,1) # The coords of the cell above
	
	# First check: mouse position in the map boundaries
	if mouse_pos in _layer0.get_used_cells():
		# Second check [Option 1]: cell on mouse position is navigable (checks if the cell above in Layer1 has a collision polygon, so entities can't pass through it)
		if _layer1.get_cell_tile_data(mouse_pos_layer1) == null || _layer1.get_cell_tile_data(mouse_pos_layer1).get_collision_polygons_count(0) == 0:
	
		## Second check [Option 2]: cell on mouse position is navigable (check custom data layer)
		#if _layer0.get_cell_tile_data(mouse_pos).get_custom_data("is_navigable") == true:
	
		## Second check [Option 3]: cell on mouse position is navigable (have Navigation Layer) - NEED CHANGE: we need a better solution to check if a cell is in Navigation Layer 1 (0)
		#if _layer0.get_cell_tile_data(mouse_pos).get_navigation_polygon(0) in nav_layer_value:
	
			# Third check: mouse position isn't over the boundaries
			if _layer0.get_cell_atlas_coords(mouse_pos) != border_value:
				print(_layer0.get_cell_atlas_coords(mouse_pos))
				return true
			else:
				MessageBus.log.emit("I cannot reach that postion...there's a border over there")
				return false
		else:
			MessageBus.log.emit("I cannot reach that postion...there's something else on top")
			return false
	else:
		MessageBus.log.emit("I cannot reach that postion...")
		return false

# Move the player to the target position
## NEED FIX - Sometimes player get stuck and ap continue to decrese
func _move(target_position: Vector2):
	_navigator.target_position = target_position
	
	# NavigationAgent has reached the target location
	if _navigator.is_navigation_finished():
		_isMoving = false
		return
		
	if _attack_mode:
		_used_ap += 1
		MessageBus.ap_remove.emit(1)
	
	# Update NavigationAgent
	if _used_ap <= AP:
		var current_navigator_position = self.global_position
		var next_path_position = _navigator.get_next_path_position()
		var new_velocity = current_navigator_position.direction_to(next_path_position) * SPEED
	
		# Our navigator is set to avoid obstacle
		if _navigator.avoidance_enabled:
			_navigator.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)
	
		move_and_slide()
	else: 
		MessageBus.log.emit("APs are finished")
		_target = self.global_position


## MessageBus related function
func _update():
	_used_ap = 0
	_attack_mode = true
	_target = self.global_position # Remove previus target

func _reset():
	_used_ap = 0
	_attack_mode = false
	_target = self.global_position # Remove previus target

# Change the player health
func _change_health(value: float):
	_health = value
