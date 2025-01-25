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

func supportMoney():
	#Increase Volume, Surface Area
	#Low - insignificant, fragile
	#Medium - move well with others
	#High - more money means more cost means
	pass
	
func supportPeers():
	#Increase Lift Force, increase competition and obstacles
	#Low - low lift, can sink
	#Medium - hovers comfortably
	#high - Competition, obstacles, and pirates
	pass
	
func supportMotivation():
	#Increase forward velocity, increase drag, and can miss power-ups
	#Low - slow forward velocity
	#Medium - good forward velocity
	#High - fast forward velocity, change to miss power-ups
	pass

func supportKnowledge():
	#Increased stability, increased density,
	#Low - easily popped
	#Medium - Can handle most obstacles
	#High - Can handle any obstacle, but slow and heavy 
	pass

func supportOrganization():
	#Float stability, float amplitude
	#Low high float amplitude
	#Medium mostly stable
	#High straight line
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_class("PlayerBubble"):
		print("absorbed")
	pass # Replace with function body.
