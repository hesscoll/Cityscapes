extends KinematicBody2D

var Knockback = Vector2.ZERO


func _physics_process(delta):
	Knockback = Knockback.move_toward(Vector2.ZERO, 150 * delta)
	Knockback = move_and_slide(Knockback)

func _on_Hurtbox_area_entered(area):
	Knockback = area.knockback_vector * 125
