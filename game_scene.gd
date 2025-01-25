extends Node2D
@export var spawners : Node2D
@onready var bubble = preload("res://selection_bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var delay = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Spawn"):
		var item = bubble.instantiate()
		item.global_position = get_global_mouse_position()
		add_child(item)
	pass
