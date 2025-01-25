extends Area2D
var target = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("loading attributes")
	var target = get_tree().get_first_node_in_group("target").global_position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if global_position.x == target.x:
		return
	else:
		if global_position.x<target.x:
			global_position.x+=1
		else:
			global_position.x-=1
	
	if global_position.y == target.y:
		return
	else:
		if global_position.y<target.y:
			global_position.y+=1
		else:
			global_position.y-=1


func _on_body_entered(body: Node2D) -> void:
	print("absorbed")
	queue_free()
	pass # Replace with function body.
