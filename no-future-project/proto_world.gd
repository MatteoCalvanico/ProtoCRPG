extends Node2D

@onready var layer0 = $Layer0
@onready var layer1 = $Layer1
@onready var layer2 = $Layer2

func _ready() -> void:
	#Let's draw every single block in a line
	for n in range(6):
		layer0.set_cell(Vector2i(8,n), 0, Vector2i(n,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
