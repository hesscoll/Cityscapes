extends KinematicBody2D


export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200


const EnemyDeathEffect = preload("res://Action RPG Resources/Effects/EnemyDeathEffect.tscn")


enum{
	IDLE,
	WANDER,
	CHASE
}



var velocity = Vector2.ZERO
var Knockback = Vector2.ZERO

var state = CHASE


onready var sprite = $AnimSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox


func _physics_process(delta):
	Knockback = Knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	Knockback = move_and_slide(Knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	Knockback = area.knockback_vector * 125
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	enemyDeathEffect.set_offset(Vector2(0,-14))
