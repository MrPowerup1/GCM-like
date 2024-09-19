extends Node

enum Message{
	id,
	join,
	userConnected,
	userDisconnected,
	lobby,
	candidate,
	offer,
	answer,
	checkIn,
	serverLobbyInfo,
	removeLobby
}

var peer = WebSocketMultiplayerPeer.new()
var users = {}
var lobbies = {}

var Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
@export var hostPort = 8915
# Called when the node enters the scene tree for the first time.
func _ready():
	if "--server" in OS.get_cmdline_args():
		#print("hosting on " + str(hostPort))
		peer.create_server(hostPort)
		
	peer.connect("peer_connected", peer_connected)
	peer.connect("peer_disconnected", peer_disconnected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	peer.poll()
	while peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		#print (packet)
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			#print(data)
			
			if data.message == Message.lobby:
				if data.type=="join":
					JoinLobby(data)
				elif data.type=="leave":
					LeaveLobby(data)
				
			if data.message == Message.offer || data.message == Message.answer || data.message == Message.candidate:
				#print("source id is " + str(data.orgPeer))
				sendToPlayer(data.peer, data)
				
			if data.message == Message.removeLobby:
				print("Remove lobby")
				if lobbies.has(data.lobbyID):
					for peer in lobbies[data.lobbyID].Players:
						peer_disconnected(peer)
					lobbies.erase(data.lobbyID)
			
			if data.message == Message.userDisconnected:
				peer.disconnect_peer(data.id)
	pass

func peer_connected(id):
	print("Peer connected to server with id ",id)
	#print("Peer Connected: " + str(id))
	users[id] = {
		"id" : id,
		"message" : Message.id
	}
	peer.get_peer(id).put_packet(JSON.stringify(users[id]).to_utf8_buffer())
	pass
	
func peer_disconnected(id):
	print("Peer disconnected from server with id ",id)
	users.erase(id)
	var disconnected = {
		"id" : id,
		"message" : Message.userDisconnected,
	}
	peer.get_peer(id).put_packet(JSON.stringify(disconnected).to_utf8_buffer())


func LeaveLobby(user):
	var result = ""
	if !lobbies.has(user.lobbyValue):
		var failed_to_leave_lobby_message = {
			"message" : Message.lobby,
			"isValid":false,
			"id" : user.id,
			"lobbyValue" : user.lobbyValue,
			"type":"leave"
		}
		sendToPlayer(user.id,failed_to_leave_lobby_message)
		return
	lobbies[user.lobbyValue].RemovePlayer(user.id)
	for p in lobbies[user.lobbyValue].Players:
		
		var player_data = {
			"message" : Message.userDisconnected,
			"id" : user.id
		}
		sendToPlayer(p, player_data)
		
		var lobbyInfo = {
			"message" : Message.lobby,
			"isValid": true,
			"players" : JSON.stringify(lobbies[user.lobbyValue].Players),
			"host" : lobbies[user.lobbyValue].HostID,
			"lobbyValue" : user.lobbyValue,
			"type":"leave"
		}
		sendToPlayer(p, lobbyInfo)
	
	var data = {
		"message" : Message.userDisconnected,
		"id" : user.id,
		"lobbyValue" : user.lobbyValue
	}
	
	sendToPlayer(user.id, data)

func JoinLobby(user):
	var result = ""
	if user.lobbyValue == "":
		user.lobbyValue = generateRandomString()
		lobbies[user.lobbyValue] = Lobby.new(user.id)
		#print(user.lobbyValue)
	if !lobbies.has(user.lobbyValue):
		var failed_to_join_lobby_message = {
			"message" : Message.lobby,
			"isValid":false,
			"id" : user.id,
			"lobbyValue" : user.lobbyValue,
			"type":"join"
		}
		sendToPlayer(user.id,failed_to_join_lobby_message)
		return
	lobbies[user.lobbyValue].AddPlayer(user.id, user.name)
	for p in lobbies[user.lobbyValue].Players.keys():
		
		var new_player_data = {
			"message" : Message.userConnected,
			"id" : user.id
		}
		sendToPlayer(p, new_player_data)
		
		var other_player_data = {
			"message" : Message.userConnected,
			"id" : p
		}
		sendToPlayer(user.id, other_player_data)
		
		var lobbyInfo = {
			"message" : Message.lobby,
			"isValid": true,
			"players" : JSON.stringify(lobbies[user.lobbyValue].Players),
			"host" : lobbies[user.lobbyValue].HostID,
			"lobbyValue" : user.lobbyValue,
			"type":"join"
		}
		sendToPlayer(p, lobbyInfo)
	
	var data = {
		"message" : Message.userConnected,
		"id" : user.id,
		"host" : lobbies[user.lobbyValue].HostID,
		"player" : lobbies[user.lobbyValue].Players[user.id],
		"lobbyValue" : user.lobbyValue,
		"type":"join"
	}
	
	sendToPlayer(user.id, data)
	
	
	
func sendToPlayer(userId, data):
	#print(data)
	peer.get_peer(userId).put_packet(JSON.stringify(data).to_utf8_buffer())
	
func generateRandomString():
	var result = ""
	for i in range(6):
		var index = randi() % Characters.length()
		result += Characters[index]
	return result

func startServer():
	peer.create_server(8915)
	#print("Started Server")

func start_then_join(lobby_id:String):
	startServer()
	await get_tree().create_timer(0.1).timeout
	Client.join_lobby(lobby_id)

func _on_button_button_down():
	var message = {
		"message" : Message.id,
		"data" : "test"
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	pass # Replace with function body.
