extends CharacterBody2D


const SPEED = 100

@onready var navigator = $NavigationAgent2D
@export var target: CharacterBody2D = null 

# This is gonna change with the enemy type [Long, mid or short range]
@export var stop_distance = 100

func _physics_process(delta: float) -> void:
	
	# Update target position
	update_position()
	
	# Need to stop the enemy before it reach the target
	# Can be upgraded with a raycaster using RayCast2D
	var distance_to_target = self.global_position.distance_to(target.global_position)
	
	# NavigationAgent has reached the target location
	if navigator.is_navigation_finished() || distance_to_target <= stop_distance:
		navigator.target_position = self.global_position
		return
	
	# Update NavigationAgent
	var current_navigator_position = self.global_position
	var next_path_position = navigator.get_next_path_position()
	var new_velocity = current_navigator_position.direction_to(next_path_position) * SPEED
	
	# Our navigator is set to avoid obstacle
	if navigator.avoidance_enabled:
		navigator.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	
	move_and_slide()


# Update the navigation target
func update_position():
	await get_tree().physics_frame # Need to wait everything is loaded
	if target:
		navigator.target_position = target.global_position


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity
