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
		print("SERVER ONLINE\n")
		%HostButton.text = "SERVER ONLINE"
		%HostButton.disabled = true
	else:
		print("CAN NOT CREATE SERVER. ERROR NUMBER: %d \n", res)

	multiplayer.multiplayer_peer = peer

	var map_instance = maps.pick_random().instantiate()
	%Map.add_child(map_instance)

	multiplayer.peer_connected.connect(
		func(id):
			print("%d has joined" % id)
			print("Number of players: %d \n" % multiplayer.get_peers().size())
			var player_instance = player.instantiate()
			player_instance.name = str(id)
			player_instance.global_position = $SpawnPosition.global_position
			%Players.add_child(player_instance)
	)

	multiplayer.peer_disconnected.connect(
		func(id):
			print("%d has left" % id)
			print("Number of players: %d \n" % multiplayer.get_peers().size())
			%Players.get_node(str(id)).queue_free()
	)


func create_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(
		func hide_GUI():
			%GUI.hide()
	)
