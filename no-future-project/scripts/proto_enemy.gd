extends CharacterBody2D


const SPEED = 100
@onready var navigator = $NavigationAgent2D
@export var target: CharacterBody2D = null 

func _ready() -> void:
	call_deferred("enemy_setup") # Need to wait everything is loaded
	pass

func enemy_setup():
	await get_tree().physics_frame
	if target:
		navigator.target_position = target.global_position

func _physics_process(delta: float) -> void:
	if navigator.is_navigation_finished():
		return
	
	navigator.target_position = target.global_position
	var current_navigator_position = self.global_position
	var next_path_position = navigator.get_next_path_position()
	var new_velocity = current_navigator_position.direction_to(next_path_position) * SPEED
	_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity
