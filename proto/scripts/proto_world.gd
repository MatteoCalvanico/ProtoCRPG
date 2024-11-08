extends Node2D

# Our layers
@onready var layer0 = $Layer0
@onready var layer1 = $Layer1
enum layers {layer0, layer1}

# NPCs
@onready var npcs = $NPCs.get_children()

# Player
@onready var player = $Player

# Enemies
@onready var enemies = $Enemies.get_children()

# Our blocks (Atlas coords)
const blue = Vector2i(0,0)
const red = Vector2i(1,0)
const green = Vector2i(2,0)
const white = Vector2i(3,0)
const black = Vector2i(4,0)
const purple_slab = Vector2i(5,0)
const orange_slab = Vector2i(6,0)
const boundery = Vector2i(0,1)


func _ready() -> void:
	MessageBus.attack_mode_on.connect(update)
	MessageBus.attack_mode_off.connect(reset)
	
	place_boundaries()

func _process(delta: float) -> void:
	pass

# Needed for create the world boundaries
func place_boundaries():
	var offsets = [ Vector2i(0,-1), Vector2i(0,1), Vector2i(-1,0), Vector2i(1,0)]
	var usedCells = layer0.get_used_cells()
	
	for cell in usedCells:
		for offeset in offsets:
			var current_spot = cell + offeset
			
			# Empty spot (method return -1 if cell do not exist)
			if layer0.get_cell_source_id(current_spot) == -1:
				layer0.set_cell(current_spot, 0, boundery)

# Needed to stop the scene when the player enter in attack mode
## To work you need the root node with Process->Mode:Inherit - If you want to make an exception put Process->Mode:Always on all nodes you don't want to be paused 
func toggle_pause():
	get_tree().paused = !get_tree().paused


## MessageBus related function
func update():
	toggle_pause()

func reset():
	toggle_pause()
