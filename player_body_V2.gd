extends CharacterBody2D
class_name PlayerBubble

@onready var startMag =[]
@onready var currentMag =[]

@export var integrityLabel : Label
@export var ScoreLabel : Label


const MONEY = 0
const SUPPORT = 1
const MOTIVE = 2
const KNOWLEDGE = 3
const PLAN = 4
const COMPETITION = 5

@onready var moneyMax = get_viewport().get_visible_rect().size.x/3 *2
@onready var supportMax = get_viewport().get_visible_rect().size.x/3 *2
@onready var competeMax = get_viewport().get_visible_rect().size.x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("default")
	pass # Replace with function body.

var radius

var health = 100
var score = 0

var lift = 0
var pressure = 0

var thrust = 0
var resistance = 0

var amplitude = 5

var degen = 0
var regen = 0

var cycle = 0

signal healthPop
signal highPop
signal lowPop
#Money increase health, increase lift, increase degen, increase resistance
#Support increase health, increase lift, increase regen, increase pressure
#Motivation increase thrust, increase degen, increase amplitude
#Knowledge increase lift, increase resistance, reduce pressure, increase regen
#Planning increase thrust, increase regen, decrease amplitude, reduce pressure
#Competition increase pressure, increase resistance, increase amplitude, 

var downMax = 100
var upMax = 100

func flyingCalc(delta):
	var moneyRatio = currentMag[MONEY]/moneyMax
	var supportRatio = currentMag[SUPPORT]/supportMax
	var motiveRatio = currentMag[MOTIVE]/startMag[MOTIVE]
	var knowledgeRatio = currentMag[KNOWLEDGE]/startMag[KNOWLEDGE]
	var planningRatio = currentMag[PLAN]/startMag[PLAN]
	var competeRatio = currentMag[COMPETITION]/competeMax
	
	print(moneyRatio," ",supportRatio," ",motiveRatio," ",knowledgeRatio," ",planningRatio, " ", competeRatio)
	scale = moneyRatio * Vector2(1,1) * 0.5
	
	var down_force = (moneyRatio+competeRatio*0.05) * get_gravity()
	var up_force = - (supportRatio) * get_gravity()
	print("net force ", up_force+down_force)
	var fwd_force = 200 * (motiveRatio)
	
	var degen = 4 * (competeRatio+motiveRatio)
	var regen = 3 * (knowledgeRatio+planningRatio)
	
	down_force.clamp(Vector2(0,0),Vector2(0,50))
	up_force.clamp(Vector2(0,-50), Vector2(0,0))
	
	position.x+= fwd_force * delta
	position.y+= (up_force.y+down_force.y)  *delta
	
	health+=(regen-degen)*delta
	score=global_position.x
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	integrityLabel.text = "Integrity: " + str(health)
	ScoreLabel.text = "scored " + str(score)

func popType():
	if health<=0:
		emit_signal("healthPop")
	
	if position.y <=-324:
		emit_signal("highPop")
	
	if position.y >=324:
		emit_signal("lowPop")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if health>=0 and position.y>-324 and position.y<324:
		$AnimationPlayer.play("default")
	else:
		$AnimationPlayer.play("pop")
	pass # Replace with function body.
