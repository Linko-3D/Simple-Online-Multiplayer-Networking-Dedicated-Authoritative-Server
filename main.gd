extends Node


const SERVER_IP = "localhost"
const SERVER_PORT = 9999

@export var player : PackedScene
@export var maps : Array[PackedScene]


func _ready():
	if OS.has_feature("dedicated_server"):
		create_server()
	else:
		create_client()


func create_server():
	var peer = ENetMultiplayerPeer.new()
	var res = peer.create_server(SERVER_PORT)

	if res == OK:
		print("DEDICATED SERVER IS RUNNING")
		print("Waiting for players to connect...\n")
		%HostButton.text = "SERVER ONLINE"
		%HostButton.disabled = true
	else:
		print(
			"CAN NOT CREATE SERVER. ERROR %d: %s\n"
			% [res, error_string(res)]
		)

	multiplayer.multiplayer_peer = peer

	var map_instance = maps.pick_random().instantiate()
	$Map.add_child(map_instance)

	multiplayer.peer_connected.connect(
		func(id):
			print("%d has joined" % id)
			print("Number of players: %d\n" % multiplayer.get_peers().size())

			var player_instance = player.instantiate()
			player_instance.name = str(id)

			var spawn_area = get_tree().get_current_scene().find_child("SpawnArea", true, false)
			var x = randi_range(0, spawn_area.size.x)
			var y = randi_range(0, spawn_area.size.y)
			player_instance.global_position = spawn_area.global_position + Vector2(x, y)

			$Players.add_child(player_instance)
	)

	multiplayer.peer_disconnected.connect(
		func(id):
			print("%d has left" % id)
			print("Number of players: %d\n" % multiplayer.get_peers().size())
			$Players.get_node(str(id)).queue_free()
	)


func create_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(
		func hide_GUI():
		$GUI.hide()
	)
