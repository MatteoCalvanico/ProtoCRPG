extends CharacterBody2D


const SPEED = 200
var isMoving: bool = false # Needed to make possible the movement with only one click

@onready var navigator = $NavigationAgent2D
@onready var camera = $Camera2D

func _physics_process(delta: float) -> void:
	
	# Camera Zoom
	if Input.is_action_just_pressed("scrollUp") && camera.zoom <= Vector2(2,2):
		camera.zoom *= 1.1
	elif  Input.is_action_just_pressed("scrollDown") && camera.zoom >= Vector2(0.5,0.5):
		camera.zoom *= 0.9
	
	
	# Move with Mouse [One click]
	if Input.is_action_just_pressed("mouseSX") || isMoving: 
		
		# Only update the target location if navigator is finished OR player wants to change location
		if !isMoving || Input.is_action_just_pressed("mouseSX"):
			navigator.target_position = self.get_global_mouse_position()
		
		isMoving = true
		
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
	else:
		# Move with WASD and Arrows [Only for debug]
		var direction = Input.get_vector("left", "right", "down", "up")
		if direction:
			self.velocity = direction * SPEED
		else :
			self.velocity = Vector2.ZERO
			
			
	move_and_slide()


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity
