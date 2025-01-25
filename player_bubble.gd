extends RigidBody2D
class_name PlayerBubble
@onready var support_force : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mass = 4/3 * PI * 10 * 3.8*pow(10,-4)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var downForce = mass * get_gravity()
	apply_central_force(Vector2(50,0))
	apply_central_force(Vector2(-))
	apply_force(support_force.move_toward(Vector2.ZERO,1)-downForce)
	pass
