extends Node2D
@export var spawners : Node2D
@onready var bubble = preload("res://selection_bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var delay = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	delay+=delta
	if delay>=1.5:
		var object = bubble.instantiate()
		object.position = Vector2(randf_range(105*3,105*5)*randi_range(-1,1),randi_range(105*3,315*5)*randi_range(-1,1))
		add_child(object)
		delay=0
