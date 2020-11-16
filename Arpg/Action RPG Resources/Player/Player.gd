extends KinematicBody2D

export var MAX_SPEED = 100
export var ACCELERATION = 15
export var FRICTION = 15
export var sprintState = 0

enum {
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
var state = MOVE
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $Position2D/SwordHitbox
onready var hurtbox = $Hurtbox

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = roll_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		
		
			
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
		
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		MAX_SPEED = 100
		sprintState = 0
		
	
	
	if Input.is_action_just_pressed("Attack"):
		MAX_SPEED = 100
		state = ATTACK
		
	if Input.is_action_just_pressed("Roll") and sprintState == 0:
		MAX_SPEED = 150
		sprintState = 1
		state = ROLL
	

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(delta):
	velocity = roll_vector * MAX_SPEED
	animationState.travel("Roll")
	
func roll_animation_end():
	if Input.is_action_pressed("Roll") and sprintState == 1:
		MAX_SPEED = 120
	state = MOVE
	
func attack_animation_end():
	state = MOVE
	
func move():
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_released("Roll") and sprintState == 1 and state != ROLL:
		MAX_SPEED = 100
		sprintState = 0
	if !Input.is_action_pressed("Roll") and sprintState == 1 and state != ROLL:
		MAX_SPEED = 100
		sprintState = 0
func _physics_process(delta):
	move()
	
	


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincible(0.5)
	hurtbox.create_hit_effect()
