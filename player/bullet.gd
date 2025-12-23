extends Node2D


const SPEED = 1000


func _process(delta):
	global_position += global_transform.x * SPEED * delta


func _on_timer_timeout() -> void:
	queue_free()
