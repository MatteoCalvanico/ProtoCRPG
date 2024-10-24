extends Node2D

# Our layers
@onready var layer0 = $Layer0
@onready var layer1 = $Layer1
enum layers { layer0, layer1}

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
	place_boundaries()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place_boundaries():
	var offsets = [ Vector2i(0,-1), Vector2i(0,1), Vector2i(-1,0), Vector2i(1,0)]
	var usedCells = layer0.get_used_cells()
	
	for cell in usedCells:
		for offeset in offsets:
			var current_spot = cell + offeset
			
			# Empty spot (method return -1 if cell do not exist)
			if layer0.get_cell_source_id(current_spot) == -1:
				layer0.set_cell(current_spot, 0, boundery)
	
func draw_block():
	#Let's draw every single block in a line
	for n in range(6):
		layer0.set_cell(Vector2i(8,n), 0, Vector2i(n,0))
