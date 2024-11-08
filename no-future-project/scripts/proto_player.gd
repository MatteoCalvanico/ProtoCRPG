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
	
	# Camera Zoom
	if Input.is_action_just_pressed("scrollUp") && camera.zoom <= Vector2(2,2):
		camera.zoom *= 1.1
	elif  Input.is_action_just_pressed("scrollDown") && camera.zoom >= Vector2(0.5,0.5):
		camera.zoom *= 0.9
	 
	#Move with Mouse [One click]
	if Input.is_action_just_pressed("mouseSX") || isMoving: 
			# Only update the target location if navigator is finiashed OR player wants to change location
			if !isMoving || Input.is_action_just_pressed("mouseSX"):
				target = self.get_global_mouse_position()
				
				# This use Layout0 coords, but when is use it in move doesn't take the right cell
				# This logic can be used to highlight the cell clicked by the user
				print(layer0.local_to_map(layer0.get_local_mouse_position()))
				layer0.set_cell(layer0.local_to_map(layer0.get_local_mouse_position()), 0, Vector2i(0,0))
				
				isMoving = true
				
			if target != null:
				move(target)
	elif OS.is_debug_build():
			# Move with WASD and Arrows [ONLY DEBUG MODE]
			var direction = Input.get_vector("left", "right", "down", "up")
			if direction:
				self.velocity = direction * SPEED
			else :
				self.velocity = Vector2.ZERO
			move_and_slide()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity

# Move the player to the target position
## NEED FIX - Sometimes player get stuck or the position clicked is ouside the map and is not reachable, ap continue to decrese
func move(target_position: Vector2):
	navigator.target_position = target_position
	print("Nav target", navigator.target_position)
	
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
		target = self.global_position




## MessageBus related function
func update():
	used_ap = 0
	attack_mode = true
	target = self.global_position # Remove the unwanted click under the attack button

func reset():
	used_ap = 0
	attack_mode = false
	target = self.global_position # Remove the unwanted click under the attack button
