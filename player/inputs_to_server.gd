extends MultiplayerSynchronizer


var input_dir : Vector2
var aim_vector = Vector2.RIGHT
var shoot = false

@export var player : Node2D


func _ready():
	set_visibility_for(1, true) # Only the server gets the inputs


func _physics_process(delta):
	if is_multiplayer_authority():
		input_dir = Input.get_vector("left", "right", "up", "down")
		aim_vector = player.global_position.direction_to(player.get_global_mouse_position())
		shoot = Input.is_action_just_pressed("shoot")
		
