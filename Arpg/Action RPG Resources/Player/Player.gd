extends KinematicBody2D

var MAX_SPEED = 100
var ACCELERATION = 15
const FRICTION = 15
var sprintState = 0

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		if Input.is_action_just_pressed("Sprint") and sprintState == 0:
			MAX_SPEED = 150
			sprintState = 1
		elif Input.is_action_just_pressed("Sprint") and sprintState == 1:
			MAX_SPEED = 100
			sprintState = 0
		
			
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
		
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		MAX_SPEED = 100
		sprintState = 0
		
	move_and_slide(velocity)
