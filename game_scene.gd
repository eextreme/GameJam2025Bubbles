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

@onready var moneyStart = moneyMag.position.x
@onready var supportStart = supportMag.position.x
@onready var motivationStart = motivationMag.position.x
@onready var knowledgeStart = knowledgeMag.position.x
@onready var planningStart = planningMag.position.x
@onready var competitionStart = competitionMag.position.x

var cur_state = states.LAUNCH
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var delay = 0	

func spawnSupport(entry):
	var item = bubble.instantiate() as SupportBubble
	item.global_position.x = global_position.x
	item.global_position.y = 324
	item.selected = entry
	add_child(item)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Support1"):
		spawnSupport(0)
		pass
	
	if Input.is_action_just_pressed("Support2"):
		spawnSupport(1)
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

func randomStart(stat : TextureRect, startPos, offset=0):
	stat.position.x=startPos+sin(count+offset)*238
	count+=randf_range(PI/720,PI/360)	
	
func launchFunction():
	playerBody.gravity_scale=0
	camera.offset.x=500
	
	randomStart(moneyMag, moneyStart)
	randomStart(supportMag,supportStart)
	
	randomStart(motivationMag,motivationStart,PI/4)
	randomStart(knowledgeMag,knowledgeStart)
	randomStart(planningMag,planningStart,PI/4)
	randomStart(competitionMag,competitionStart)
	
	if Input.is_action_just_pressed("launch"):
		camera.offset=Vector2.ZERO
		playerBody.startMag =[moneyStart,supportStart,motivationStart,knowledgeStart,planningStart,competitionStart]
		cur_state=states.FLYING
	pass

func flyingFunction(delta):
	playerBody.currentMag =[
			moneyMag.position.x,
			supportMag.position.x,
			motivationMag.position.x,
			knowledgeMag.position.x,
			planningMag.position.x,
			competitionMag.position.x]
	playerBody.flyingCalc(delta)
	camera.global_position = playerBody.global_position
	pass
	
func popFunction():
	pass

func goalFunction():
	pass
