extends Node

@export var address = "127.0.0.1"
@export var port = 9999
@export var max_clients = 4
var peer

signal wait_for_players
signal player_joined

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


#When player connects, all clients and host call this. New client calls it for each other player already connected
func player_connected(id):
	print("connected ", id)

#All remaining clients get called
func player_disconnected(id):
	print("disconnected ", id)

#Called just on this client
func connected_to_server():
	print("Connected to server")
	send_player_info.rpc_id(1, multiplayer.get_unique_id(), 0)
	player_joined.emit()

#Called just on this client
func connection_failed():
	print ("Failed Connection")

#@rpc("any_peer","call_local")
#func start_game():
#	wait_for_players.emit()

@rpc("any_peer")
func send_player_info(id,local_index):
	if !GameManager.players.has(id):
		GameManager.players [id] = {
			"id":id,
			"local_index":local_index
		}
	if multiplayer.is_server():
		for player in GameManager.players:
			send_player_info.rpc(player,GameManager.players[player].local_index)

func _on_local_button_down():
	wait_for_players.emit()


func _on_host_button_down():
	print("Hosting")
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port,4)
	if error != OK:
		printerr("Can't host, error appeared ", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Now waiting for players ")
	send_player_info(multiplayer.get_unique_id(),0)
	wait_for_players.emit()
	


func _on_join_button_down():
	print("Joining")
	peer = ENetMultiplayerPeer.new()
	var error
	if %IP.text == "":
		error = peer.create_client(address,port)
	else:
		error = peer.create_client(%IP.text,port)
	if error != OK:
		printerr("Can't join, error appeared ", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	wait_for_players.emit()
	


func _on_start_button_down():
	pass
#	start_game.rpc()
