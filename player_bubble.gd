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
var surfaceTension: float #increased and descreased by knowledge, competition, drag
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

func updateSphereInfo():
	var ratio = currentMag[MONEY]/startMag[MONEY]
	radius = 50 * ratio/1000
	$CollisionShape2D.scale = ratio * Vector2(1,1)
	volume = 4/3*PI*pow(radius,3)
	surfaceArea = 4*PI*pow(radius,2)
	mass = 4/3 * PI * radius * 3.8*pow(10,-4)

@onready var air_density = 0.1

@onready var air_d = 0.001
@onready var gas_d = 0.002

@onready var liftTimer = 3
func updateLiftInfo(delta):
	upForce = 3 * (air_d - gas_d) * get_gravity()
	liftTimer-=delta
	if liftTimer<=0:
		print("upPulse: ", upForce)
		apply_central_impulse(upForce)
		liftTimer = 3

@onready var pressureTimer = 3
func updateDownInfo(delta):	
	downForce = 3 * (gas_d - air_d) * get_gravity()
	pressureTimer-=delta
	if pressureTimer<=0:
		print("downPulse: ", downForce)
		apply_central_impulse(downForce)
		pressureTimer = 3

@onready var driveTimer = 2
func updateForwardInfo(delta): #add drag
	forwardForce = 3 * (gas_d-air_d) * Vector2(10,0)
	driveTimer-=delta
	if driveTimer<=0:
		print("forwardPulse: ",forwardForce)
		apply_central_impulse(forwardForce)
		driveTimer=2

@onready var addAmp = 1
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

func flyingCalc(delta):
	updateSphereInfo()
	updateLiftInfo(delta)
	updateDownInfo(delta)
	updateForwardInfo(delta)
	updateWobbleInfo(delta)
	spawnObstacle(delta)
	
	gravity_scale =  currentMag[COMPETITION]/startMag[COMPETITION] * delta
	
	
	
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
	
