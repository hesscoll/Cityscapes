extends Area2D



const HitEffect = preload("res://Action RPG Resources/Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincible_start
signal invincible_end


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincible_start")
	else:
		emit_signal("invincible_end")

func start_invincible(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincible_start():
	set_deferred("monitorable", false)


func _on_Hurtbox_invincible_end():
	set_deferred("monitorable", true)
