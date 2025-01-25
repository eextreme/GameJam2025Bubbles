extends RigidBody2D
class_name SupportBubble
var target = Vector2.ZERO
@export var air_d : float = 0.001
@export var gas_d : float = 0.002
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("loading attributes")
	var target = get_tree().get_first_node_in_group("target").global_position
	mass = 4/3 * PI * 10 * 3.8*pow(10,-4)
	
	pass # Replace with function body.

var start = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	start+=1
	var floatForce = 3 * (air_d - gas_d) * get_gravity()
	var downForce = mass * get_gravity()
	var drag = sin(start)*Vector2(20,20)
	
	print("float:",floatForce,"down:",downForce)
	
	var forceRng = Vector2(randf_range(-0.1,0.1),randf_range(-0.1,0.1))
	apply_central_force(floatForce-downForce+drag+forceRng)
	
	pass

func supportBubbleEffect(body : PlayerBubble):
	body.support_force+=3 * (air_d - gas_d) * get_gravity()
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_class("PlayerBubble"):
		supportBubbleEffect(body)
	pass # Replace with function body.
