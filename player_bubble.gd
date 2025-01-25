extends RigidBody2D
class_name PlayerBubble
@onready var support_force : Vector2 = Vector2.ZERO

var volume: float
var surfaceArea: float
var surfaceTension: float
var upForce : Vector2
var downForce : Vector2
@export var camera : Camera2D

enum states {
	LAUNCH,
	FLYING,
	POP,
	GOAL,
}

var cur_state = states.LAUNCH
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mass = 4/3 * PI * 10 * 3.8*pow(10,-4)
	
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match cur_state:
		states.LAUNCH:
			launchFunction()
		states.FLYING:
			flyingFunction()
		states.POP:
			popFunction()
		states.GOAL:
			goalFunction()
	
	#states
	#launch
	#flying
	pass

func launchFunction():
	gravity_scale=0
	camera.offset.x=500
	
	pass

func flyingFunction():
	pass
	
func popFunction():
	pass

func goalFunction():
	pass
