extends CharacterBody2D


const SPEED = 200
var isMoving: bool = false # Needed to make possible the movement with only one click
var attack_mode = false
var target = null

@onready var navigator = $NavigationAgent2D
@onready var camera = $Camera2D


func _ready() -> void:
	MessageBus.attack_mode_on.connect(update)
	MessageBus.attack_mode_off.connect(reset)

func _physics_process(delta: float) -> void:
	
	# Camera Zoom
	if Input.is_action_just_pressed("scrollUp") && camera.zoom <= Vector2(2,2):
		camera.zoom *= 1.1
	elif  Input.is_action_just_pressed("scrollDown") && camera.zoom >= Vector2(0.5,0.5):
		camera.zoom *= 0.9
	 
	# Move only if we are not in ATTACK MODE
	if !attack_mode:
		# Move with Mouse [One click]
		if Input.is_action_just_pressed("mouseSX") || isMoving: 
			
			# Only update the target location if navigator is finiashed OR player wants to change location
			if !isMoving || Input.is_action_just_pressed("mouseSX"):
				target = self.get_global_mouse_position()
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
	else:
		target = self.global_position # Remove the click under the attack button

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity

# Move the player to the target position
func move(target_position: Vector2):
	navigator.target_position = target_position
	
	# NavigationAgent has reached the target location
	if navigator.is_navigation_finished():
		isMoving = false
		return
	
	# Update NavigationAgent
	var current_navigator_position = self.global_position
	var next_path_position = navigator.get_next_path_position()
	var new_velocity = current_navigator_position.direction_to(next_path_position) * SPEED
	
	# Our navigator is set to avoid obstacle
	if navigator.avoidance_enabled:
		navigator.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	move_and_slide()


## MessageBus related function
func update():
	attack_mode = true

func reset():
	attack_mode = false
