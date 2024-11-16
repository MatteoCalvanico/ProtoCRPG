## This script is used in the terrain layer (Layer0) for update NavigationLayer
extends TileMapLayer

@onready var _layer1 = $"../Layer1" # Layer that has obstacle, otherwise we can use an array to contains all the layer with obstacles and fill it in the _ready


# Overrided function - represents whether the cell at coords needs to have its data updated in runtime
func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	# We remove Vector2i(1,1) from the coord to take the right cell, and remove the nav layer from the bottom part
	return _is_cell_occupied(coords - Vector2i(1,1))

# Overrided function
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)

# Check if the cell coords are occupied
func _is_cell_occupied(coords: Vector2i) -> bool:
	if coords in _layer1.get_used_cells():
		if _layer1.get_cell_tile_data(coords).get_collision_polygons_count(0) > 0:
			return true
	return false
