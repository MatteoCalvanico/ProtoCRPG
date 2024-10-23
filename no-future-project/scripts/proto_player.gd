extends CharacterBody2D


const SPEED = 200

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "down", "up")
	if direction:
		self.velocity = direction * SPEED
	else :
		self.velocity = Vector2.ZERO

	move_and_slide()
