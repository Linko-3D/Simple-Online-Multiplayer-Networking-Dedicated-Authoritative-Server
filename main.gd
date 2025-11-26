extends Node


const SERVER_IP = "localhost" # Replace it with the server’s public DNS
const SERVER_PORT = 8080

@export var player : PackedScene
@export var maps : Array[PackedScene]


func _ready():
	if OS.has_feature("release"):
		$Debug.queue_free()

	if OS.has_feature("dedicated_server"):
		create_server()
	else:
		create_client()


func create_server():
	var peer = ENetMultiplayerPeer.new()
	var res = peer.create_server(SERVER_PORT)

	if res != OK:
		return

	multiplayer.multiplayer_peer = peer
	
	var map_instance = maps.pick_random().instantiate()
	$Map.add_child(map_instance)

	print("DEDICATED SERVER IS RUNNING")
	print("Waiting for players to join...\n")
	%HostButton.text = "SERVER ONLINE"
	%HostButton.disabled = true

	multiplayer.peer_connected.connect(
		func(id):
			print("%d has joined" % id)
			print("Number of players: %d\n" % multiplayer.get_peers().size())

			var player_instance = player.instantiate()
			player_instance.name = str(id)

			var spawn_area = get_tree().get_nodes_in_group("spawn_area").pick_random()
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

	if OS.has_feature("release"):
		peer.create_client(SERVER_IP, SERVER_PORT)
	else:
		peer.create_client("localhost", SERVER_PORT)

	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(
		func hide_GUI():
		%HostButton.hide()
	)

	multiplayer.server_disconnected.connect(func ():
		%HostButton.show()
		$ConnectLabel.text = "Connection lost — trying to reconnect…"
		create_client()
	)
