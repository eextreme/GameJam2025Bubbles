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

#Money increase health, increase lift, increase degen, increase resistance
#Support increase health, increase lift, increase regen, increase pressure
#Motivation increase thrust, increase degen, increase amplitude
#Knowledge increase lift, increase resistance, reduce pressure, increase regen
#Planning increase thrust, increase regen, decrease amplitude, reduce pressure
#Competition increase pressure, increase resistance, increase amplitude, 
func moneyEffect(delta):
	var moneyRatio = currentMag[MONEY]/moneyMax
	lift-=25*moneyRatio * delta
	thrust+=25*moneyRatio * delta
	
	pass

func supportEffect(delta):
	var supportRatio = currentMag[SUPPORT]/supportMax
	lift-=25*supportRatio * delta
	thrust+=10*supportRatio * delta
	regen+=5*supportRatio * delta
	
	pass

func motiveEffect(delta):
	var motiveRatio = currentMag[MOTIVE]/startMag[MOTIVE]
	lift-=10*motiveRatio * delta
	thrust+=16*motiveRatio * delta
	regen+=4*motiveRatio * delta
	
	
	pass

func knowledgeEffect(delta):
	var knowledgeRatio = currentMag[KNOWLEDGE]/startMag[KNOWLEDGE]
	lift-=7 *knowledgeRatio * delta
	thrust+=10*knowledgeRatio * delta
	regen+=3*knowledgeRatio * delta
	
	pass

func planningEffect(delta):
	var planningRatio = currentMag[PLAN]/startMag[PLAN]
	lift-=3*planningRatio * delta
	thrust+=5*planningRatio * delta
	regen+=2*planningRatio * delta
	
	pass

var compMagnitude = 75

func competitionRatio(delta):
	var competeRatio = currentMag[COMPETITION]/competeMax
	pressure+=69*competeRatio * delta
	resistance+=65*competeRatio * delta
	degen+=13*competeRatio * delta
	print(pressure," ", resistance)
	pass


func flyingCalc(delta):
	cycle+=PI/360
	
	var ratio = currentMag[MONEY]/moneyMax
	radius = 10 * ratio
	$CollisionShape2D.scale = ratio * Vector2(1,1)
	
	moneyEffect(delta)
	supportEffect(delta)
	motiveEffect(delta)
	knowledgeEffect(delta)
	planningEffect(delta)
	competitionRatio(delta)
	
	#print("Lift: ",lift, " Thrust: ", thrust, " Regen: ", regen)
	#print("Lift: ",lift+abs(lift)*competitionRatio(delta), " Thrust: ", thrust-abs(thrust)*competitionRatio(delta), " Regen: ", regen)
	
	var thrustMag = (thrust-resistance)+randi_range(-amplitude,amplitude)
	var liftMag = (lift+pressure)+randi_range(-amplitude,amplitude)
	
	position.x += thrustMag*delta
	position.y += liftMag*delta
	
	#velocity.y-=100
	#print("Fall Speed: ", velocity )
	
	


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	integrityLabel.text = "Integrity: " + str(health)
	ScoreLabel.text = "Score: " + str(score)
