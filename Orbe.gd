extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called when a body enters into the Area
func _on_Orbe_body_entered(body):
	if body.name == "Hero":
		var resources = get_node("/root/Resources")
		resources.points += 1 
		body.update_life_counter()
		queue_free()
