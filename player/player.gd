extends CharacterBody2D


const SPEED = 500.0

@export var bullet : PackedScene


func _ready():
	%DisplayControllerPlayer.visible = name.to_int() == multiplayer.get_unique_id()
	$InputsToServer.set_multiplayer_authority(name.to_int())
	set_physics_process(multiplayer.is_server())

	if multiplayer.is_server():
		$Sprite2D.modulate = Color.from_hsv(randf(), 0.5, 1.0)


func _physics_process(delta: float):
	if $InputsToServer.shoot:
		print("shooting")
		var bullet_instance = bullet.instantiate()
		get_tree().get_root().add_child(bullet_instance)
	
	
	var direction = $InputsToServer.input_dir
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

	$Sprite2D.look_at($Sprite2D.global_position + $InputsToServer.aim_vector)
	$Sprite2D.global_rotation = direction.angle()
