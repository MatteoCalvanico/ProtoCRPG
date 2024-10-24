extends CharacterBody2D


const SPEED = 200
@onready var navigator = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	# Move with Mouse [NEED FIX: si blocca negli angoli e il navigator non individua i muri]
	if Input.is_action_pressed("mouseSX"):
		var mouse_position = get_global_mouse_position()
		navigator.target_position = mouse_position
		
		var current_navigator_position = self.global_position
		var next_path_position = navigator.get_next_path_position()
		var new_velocity = current_navigator_position.direction_to(next_path_position) * SPEED
		
		# When the navigation has ended
		if navigator.is_navigation_finished():
			return
		
		if navigator.avoidance_enabled:
			navigator.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
	else:
		# Move with WASD and Arrows
		var direction = Input.get_vector("left", "right", "down", "up")
		if direction:
			self.velocity = direction * SPEED
		else :
			self.velocity = Vector2.ZERO
	
	
	move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity
