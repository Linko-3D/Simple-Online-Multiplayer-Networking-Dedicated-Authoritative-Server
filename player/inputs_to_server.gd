extends MultiplayerSynchronizer


var input_dir : Vector2


func _ready():
	set_visibility_for(1, true)


func _physics_process(delta):
	if is_multiplayer_authority():
		input_dir = Input.get_vector("left", "right", "up", "down")
