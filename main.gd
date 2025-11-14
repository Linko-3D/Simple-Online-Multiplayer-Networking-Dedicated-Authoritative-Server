extends Node


const SERVER_IP = "localhost"
const SERVER_PORT = 9999

@export var player : PackedScene


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
	else:
		print("CAN NOT CREATE SERVER. ERROR NUMBER: %d \n", res)

	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(
		func(id):
			print("%d has joined" % id)
			print("Number of players: %d \n" % multiplayer.get_peers().size())
			var player_instance = player.instantiate()
			player_instance.name = str(id)
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
