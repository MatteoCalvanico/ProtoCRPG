extends CharacterBody2D

const StarBuilder = preload("res://scripts/utils/stargrid_creator.gd")
@onready var _layer = $"../../Layer0"
@onready var _player = $"../../Player"

var starBuilder: AStarGridBuilder
var path: Array[Vector2] = []
var current_waypoint: int = 0
var last_player_position: Vector2

# TODO: Sometimes throw error Pos Out of bound

func _ready() -> void:
	starBuilder = AStarGridBuilder.new(_layer)
	last_player_position = _player.global_position
	update_path(starBuilder)

func update_path(starBuilder) -> void:
	path = starBuilder.go_to(global_position, _player.global_position, self)
	current_waypoint = 0

func _physics_process(delta: float) -> void:
	# Check if the player has moved
	if last_player_position.distance_to(_player.global_position) > 10:
		update_path(starBuilder)
		last_player_position = _player.global_position
	
	# Check if we arrived to destination
	if path.is_empty() or current_waypoint >= path.size():
		update_path(starBuilder)
		return

	# Movement logic
	var target = path[current_waypoint]
	var direction = (target - global_position).normalized()
	velocity = direction * 100  
	
	if global_position.distance_to(target) < 5: 
		current_waypoint += 1
		
		if current_waypoint >= path.size():
			path.clear()
	
	move_and_slide()

#
#const SPEED = 100
#
#@onready var _navigator = $NavigationAgent2D
#@export var _target: CharacterBody2D = null 
#
## This is gonna change with the enemy type [Long, mid or short range]
#@export var _stop_distance = 100
#
#func _physics_process(delta: float) -> void:
	#
	## Update target position
	#_update_position()
	#
	## Need to stop the enemy before it reach the target
	## Can be upgraded with a raycaster using RayCast2D
	#var distance_to_target = self.global_position.distance_to(_target.global_position) # If you obtain error here you forgot to assign a target, see Inspector -> proto_enemy.gd -> Target
	#
	## NavigationAgent has reached the target location
	#if _navigator.is_navigation_finished() || distance_to_target <= _stop_distance:
		#_navigator.target_position = self.global_position
		#return
	#
	## Update NavigationAgent
	#var current_navigator_position = self.global_position
	#var next_path_position = _navigator.get_next_path_position()
	#var new_velocity = current_navigator_position.direction_to(next_path_position) * SPEED
	#
	## Our navigator is set to avoid obstacle
	#if _navigator.avoidance_enabled:
		#_navigator.set_velocity(new_velocity)
	#else:
		#_on_navigation_agent_2d_velocity_computed(new_velocity)
	#
	#
	#move_and_slide()
#
#
## Update the navigation target
#func _update_position():
	#await get_tree().physics_frame # Need to wait everything is loaded
	#if _target:
		#_navigator.target_position = _target.global_position
#
#
#func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	#self.velocity = safe_velocity
