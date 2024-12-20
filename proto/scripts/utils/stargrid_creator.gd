## This script is used whenever you need to create AStarGrid2D
class_name AStarGridBuilder extends Node


# Layer we want to use with the star grid
@onready var _tileMap: TileMapLayer

# StarGrid returned
var _starGrid= AStarGrid2D.new()


## Constructor - Initialize AStarGrid2D with layer information
#  DON'T use this, instead use AStarGridBuilder.new() that already call this function
func _init(layer: TileMapLayer) -> void:
	_tileMap = layer
	
	## Start to create the AStarGrid2D
	_starGrid.cell_size = _tileMap.tile_set.tile_size
	_starGrid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN # We set the isometric shape
	_starGrid.region = _tileMap.get_used_rect() # StarGrid size
	_starGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES # Pathfindig using as little diagonal movements as possible
	_starGrid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN # Is SLD (Straight Line Distance)
	_starGrid.jumping_enabled = false # No jumping, we don't want to skip position
	_starGrid.update() 
	
	## Start adding blocker - Remove spots where entity cannot stay or pass
	#  Thanks to the nav_updater we simply check if the cell have a nav layer - TODO: Fix this, doesn't work
	var used_cells = _tileMap.get_used_cells()
	for cell in used_cells:
		if _tileMap.get_cell_tile_data(cell).get_navigation_polygon(0).get_outline_count() == 0:
			_starGrid.set_point_solid(cell)


## Return the var with the given name
#  starGrid --return--> the AStarGrid2D created previously
func _get(property: StringName) -> Variant:
	if property == "starGrid":
		return _starGrid
	
	return null


## Return the path found in global coordinate - If isn't possible to reach the target return empty array
# TODO: Fix, i don't know why but count even the space where block are not present, even if the solid point are located in the right place
func go_to(from: Vector2i, to: Vector2i, whoMove: Object) -> Array[Vector2]:
	var path = _starGrid.get_id_path(coord_global_to_map(from, whoMove), coord_global_to_map(to, whoMove))
	return coords_map_to_global(path, whoMove)


## !!! Convertion functions !!!
# Convert a list of coords: map --> local --> global
func coords_map_to_global(coords: Array[Vector2i], caller: Object) -> Array[Vector2]:
	var new_coords_local: Array[Vector2] = []
	new_coords_local.assign(coords.map(_tileMap.map_to_local))
	var new_coords_global: Array[Vector2] = []
	new_coords_global.assign(new_coords_local.map(caller.to_global))
	return new_coords_global

# Convert a single pair of coord: map <-- local <-- global
func coord_global_to_map(coord: Vector2i, caller: Object) -> Vector2i:
	var new_coord_local = caller.to_local(coord)
	var new_coord_map = _tileMap.local_to_map(new_coord_local)
	return new_coord_map

# Like the previous one: map --> local --> global
func coord_map_to_global(coord: Vector2i, caller: Object) -> Vector2i:
	var new_coord_local = _tileMap.map_to_local(coord)
	var new_coord_global = caller.to_global(new_coord_local)
	return new_coord_global
