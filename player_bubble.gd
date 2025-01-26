extends RigidBody2D
class_name PlayerBubble

enum magTypes {
	MONEY,
	SUPPORT,
	MOTIVE,
	KNOWLEDGE,
	PLAN,
	COMPETITION
}

const MONEY = 0
const SUPPORT = 1
const MOTIVE = 2
const KNOWLEDGE = 3
const PLAN = 4
const COMPETITION = 5

@onready var support_force : Vector2 = Vector2.ZERO
@onready var startMag = {}
@onready var currentMag = {}

var volume: float #calculated
var surfaceArea: float #calculated
var radius: float #increased and decreased by money
var upForce : Vector2 #increased and decreased by peer support
var downForce : Vector2 #increased and decreased by competition
var forwardForce : Vector2 #increased and decreased by motivation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

@onready var thickness = pow(10,-6)
@onready var liquidDensity = 1000
@onready var airDensity = 1.225
@onready var drag = 0.5
@onready var gravity = Vector2(0,9.81)
@onready var heavyIntent = 1.200
@onready var applyForce = 0.01
@onready var addAmp = 1
@onready var surfaceTension = 0.072

func updateSphereInfo():
	var ratio = currentMag[MONEY]/startMag[MONEY]
	radius = 10 * ratio/100
	$CollisionShape2D.scale = ratio * Vector2(1,1)
	surfaceArea = 4*PI*pow(radius,2)
	volume = surfaceArea * thickness
	mass = volume * liquidDensity
	
	applyForce = Vector2(0.01 * currentMag[MOTIVE]/startMag[MOTIVE], 0.01 * currentMag[SUPPORT]/startMag[SUPPORT])
	addAmp = 1 * currentMag[PLAN]/startMag[PLAN]
	surfaceTension = 0.72 * currentMag[KNOWLEDGE]/startMag[KNOWLEDGE]

@onready var liftTimer = 3
func updateLiftInfo(delta):
	var v = 4/3 * PI * pow(radius,3)
	upForce = v * airDensity * get_gravity()
	return upForce

@onready var pressureTimer = 3
func updateDownInfo(delta):	
	var v = 4/3 * PI * pow(radius,3)
	downForce = v * heavyIntent * get_gravity()
	return downForce

@onready var driveTimer = 2
func updateForwardInfo(delta): #add drag
	return applyForce

@onready var startAngel = 0

func updateWobbleInfo(delta):
	startAngel+=PI*delta
	global_position.y+=addAmp*sin(startAngel)

@onready var obstacle = preload("res://obstacle.tscn")

var obstacleTimer = 2
func spawnObstacle(delta):
	obstacleTimer-=delta
	if obstacleTimer<=0:
		var entry = obstacle.instantiate() as Area2D
		entry.global_position.x = global_position.x+570
		entry.global_position.y = global_position.y+randf_range(-300,300)
		add_child(entry)
		entry.reparent(get_tree().root)
		obstacleTimer = 2

func stabilityCheck(delta):
	var surface_f = 2 * surfaceTension * 2 * PI * radius
	var p_diff = 4 * surfaceTension/radius
	var p_pop = p_diff * surfaceArea
	
	var drag_x = 0.5 * drag * airDensity * surfaceArea * pow(linear_velocity.x,2)/50
	var drag_y = 0.5 * drag * airDensity * surfaceArea * pow(linear_velocity.y,2)/50
	print("p_pop: ", p_pop, " drag_force_x: ", drag_x, " drag_force_y: ", drag_y)
	
	if drag_x > p_pop or drag_y>p_pop:
		print("you popped")
		get_tree().paused = true
	
	pass

func flyingCalc(delta):
	updateSphereInfo()
	var up = updateLiftInfo(delta)
	var down = updateDownInfo(delta)
	var fwd = updateForwardInfo(delta)
	updateWobbleInfo(delta)
	spawnObstacle(delta)
	stabilityCheck(delta)
	
	gravity_scale =  currentMag[COMPETITION]/startMag[COMPETITION] * delta
	
	apply_central_force((up-down)-mass*get_gravity()+fwd*Vector2(1,0))
	
	##if Input.is_action_just_pressed("Support1"):
		##apply_central_impulse(Ve)
	#
#
	#
	#if linear_velocity.x<=0:
		#forwardForce = 100*currentMag[MOTIVE]/startMag[MOTIVE] * Vector2(1,0) * pow(10,-4)
	#else:
		#forwardForce.move_toward(Vector2.ZERO,2)
	#
	#print("mass: ",mass, " position: ", global_position, " upforce: ", upForce, " downforce: ", downForce, " forwardForce: ", forwardForce, " speed:", linear_velocity)
	#print("total force: ",upForce+downForce+forwardForce, " linear velocity: ",linear_velocity)
	#apply_central_impulse((forwardForce+upForce))
	
