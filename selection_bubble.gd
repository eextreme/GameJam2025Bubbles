extends RigidBody2D
class_name SupportBubble
var target = Vector2.ZERO
@export var air_d : float = 0.001
@export var gas_d : float = 0.002

enum launchType {
	MONEY,
	SUPPORT,
	MOTIVATION,
	KNOWLEDGE,
	PLAN
}

var selected = 0
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
	
	print("float:",floatForce,"down:",downForce,"global_pos",global_position)
	
	var forceRng = Vector2(randf_range(-0.1,0.1),randf_range(-0.1,0.1))
	apply_central_force(floatForce-downForce+drag+forceRng)
	
	if global_position.y<-1000 or global_position.x>1000:
		queue_free()
	
	pass

func supportMoney():
	print("Support with Money")
	#Increase Radius
	#Low - insignificant, fragile
	#Medium - move well with others
	#High - more money means more cost means
	pass
	
func supportPeers():
	print("Support with Peers")
	#Increase Lift Force, increase competition and obstacles
	#Low - low lift, can sink
	#Medium - hovers comfortably
	#high - Competition, obstacles, and pirates
	pass
	
func supportMotivation():
	print("Support with Motivation")
	#Increase forward velocity, increase drag, and can miss power-ups
	#Low - slow forward velocity
	#Medium - good forward velocity
	#High - fast forward velocity, change to miss power-ups
	pass

func supportKnowledge():
	print("Support with Knowledge")
	#Increased stability, increased density,
	#Low - easily popped
	#Medium - Can handle most obstacles
	#High - Can handle any obstacle, but slow and heavy 
	pass

func supportPlanning():
	print("Support with Planning")
	#Float stability, float amplitude
	#Low high float amplitude
	#Medium mostly stable
	#High straight line
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("target"):
		print("absorbed")
		match selected:
			launchType.MONEY:
				supportMoney()
			launchType.SUPPORT:
				supportPeers()
			launchType.MOTIVATION:
				supportMotivation()
			launchType.KNOWLEDGE:
				supportKnowledge()
			launchType.PLAN:
				supportPlanning()
		queue_free()
	pass # Replace with function body.
