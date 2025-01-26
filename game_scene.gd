extends Node2D
@onready var bubble = preload("res://selection_bubble.tscn")
@export var moneyMag : TextureRect
@export var supportMag : TextureRect
@export var motivationMag : TextureRect
@export var knowledgeMag : TextureRect
@export var planningMag : TextureRect
@export var competitionMag : TextureRect
@export var camera : Camera2D
@export var playerBody : PlayerBubble

enum states {
	LAUNCH,
	FLYING,
	POP,
	GOAL,
}

enum magTypes {
	MONEY,
	SUPPORT,
	MOTIVE,
	KNOWLEDGE,
	PLAN,
	COMPETITION
}

@onready var moneyMax = moneyMag.position.x
@onready var supportMax = supportMag.position.x
@onready var competitionMax = competitionMag.position.x

@onready var motivationStart = motivationMag.position.x
@onready var knowledgeStart = knowledgeMag.position.x
@onready var planningStart = planningMag.position.x


var cur_state = states.LAUNCH
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var delay = 0	

func spawnSupport(entry):
	var magArray = [moneyMag, supportMag, motivationMag, knowledgeMag,planningMag]
	var item = bubble.instantiate() as SupportBubble
	item.global_position.x = playerBody.global_position.x
	item.global_position.y = playerBody.global_position.y+324
	item.selected = entry
	
	magArray[entry].position.x+=5
	playerBody.health-=(5-entry)*10
	add_child(item)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Support1"):
		spawnSupport(0)
		competitionMag.position.x+=1
		pass
	
	if Input.is_action_just_pressed("Support2"):
		spawnSupport(1)
		competitionMag.position.x+=1
		pass
	
	if Input.is_action_just_pressed("Support3"):
		spawnSupport(2)
		pass
	
	if Input.is_action_just_pressed("Support4"):
		spawnSupport(3)
		pass
	
	if Input.is_action_just_pressed("Support5"):
		spawnSupport(4)
		pass
	
	if Input.is_action_just_pressed("Spawn"):
		var item = bubble.instantiate() as SupportBubble
		item.global_position = get_global_mouse_position()
		item.selected = 0
		add_child(item)
	
	match cur_state:
		states.LAUNCH:
			launchFunction()
		states.FLYING:
			flyingFunction(delta)
		states.POP:
			popFunction()
		states.GOAL:
			goalFunction()

var dirMag = 1
var count = -2*PI

func randomStart(stat : TextureRect, startPos, offset=0, mag=100 ):
	stat.position.x=startPos+sin(count+offset)*mag
	count+=randf_range(PI/720,PI/360)	

func launchFunction():
	#playerBody.gravity_scale=0
	playerBody.visible = false
	camera.offset.x=500
	
	randomStart(moneyMag, moneyMax,0,45)
	randomStart(supportMag,supportMax,PI/4,45)
	#randomStart(competitionMag,competitionStart)
	
	randomStart(motivationMag,motivationStart,PI/4)
	randomStart(knowledgeMag,knowledgeStart)
	randomStart(planningMag,planningStart,PI/6)
	
	
	if Input.is_action_just_pressed("launch"):
		camera.offset=Vector2.ZERO
		playerBody.startMag =[moneyMax,supportMax,motivationStart,knowledgeStart,planningStart,competitionMax]
		playerBody.visible = true
		cur_state=states.FLYING
	pass

func flyingFunction(delta):
	playerBody.currentMag =[
			moneyMag.global_position.x,
			supportMag.global_position.x,
			motivationMag.position.x,
			knowledgeMag.position.x,
			planningMag.position.x,
			competitionMag.global_position.x]
	playerBody.flyingCalc(delta)
	playerLossCalc(delta)
	camera.global_position = playerBody.global_position
	pass

var moneyLoss = 1
var supportLoss = 1
var motiveLoss = 1
var knowledgeLoss = 1
var planningLoss = 1

func tickLoss(target, entry : TextureRect, delta, time, minValue):
	target-=delta
	if target<=0 and entry.position.x>minValue:
		entry.position.x-=randf_range(1,3)
		return time
	else:
		return target

func playerLossCalc(delta):
	moneyLoss = tickLoss(moneyLoss, moneyMag,delta, 1,1)
	supportLoss = tickLoss(supportLoss, supportMag,delta, 1,1)
	
	motiveLoss = tickLoss(motiveLoss, motivationMag,delta, 1,0)
	knowledgeLoss = tickLoss(knowledgeLoss, knowledgeMag,delta, 1,0)
	planningLoss = tickLoss(planningLoss, planningMag,delta, 1,0)

func popFunction():
	pass

func goalFunction():
	pass
