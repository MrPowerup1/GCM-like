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
var id = 0
var rtcPeer : WebRTCMultiplayerPeer = WebRTCMultiplayerPeer.new()
var hostId :int
var lobbyValue = ""
var lobbyInfo = {}

signal start
signal wait_for_peers
signal peer_joined
signal new_lobby_id(new_id:String)
signal loaded_lobby()
signal failed_to_load_lobby(lobby_id:String)
signal peer_disconnect(id:String)
signal host_changed(id:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(RTCServerConnected)
	multiplayer.peer_connected.connect(RTCPeerConnected)
	multiplayer.peer_disconnected.connect(RTCPeerDisconnected)
	pass # Replace with function body.

func RTCServerConnected():
	print("RTC server connected")

func RTCPeerConnected(id):
	print("rtc peer connected " + str(id))
	peer_joined.emit()
	SyncManager.add_peer(id)
	
	
func RTCPeerDisconnected(id):
	print("rtc peer disconnected " + str(id))
	peer_disconnect.emit(id)
	SyncManager.remove_peer(id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			
			if data.message == Message.id:
				id = data.id
				connected(id)
				
			if data.message == Message.userConnected:
				#GameManager.Players[data.id] = data.player
				print("User connected")
				createPeer(data.id)
			
			if data.message == Message.userDisconnected:	
				print("Disconnect")
				#GameManager.peers.erase(data.id)
			
			if data.message == Message.lobby:
				if data.isValid:
					GameManager.peers = JSON.parse_string(data.players)
					update_host(data.host)
					#hostId = data.host
					lobbyValue = data.lobbyValue
					#wait_for_peers.emit()
					#loaded_lobby.emit()
					##REMOVE THIS PRINT
					#print("Loaded Sucessfully")
					new_lobby_id.emit(lobbyValue)
				else:
					failed_to_load_lobby.emit(data.lobbyValue)
				
			if data.message == Message.candidate:
				if rtcPeer.has_peer(data.orgPeer):
					print("Got Candididate: " + str(data.orgPeer) + " my id is " + str(id))
					rtcPeer.get_peer(data.orgPeer).connection.add_ice_candidate(data.mid, data.index, data.sdp)
			
			if data.message == Message.offer:
				if rtcPeer.has_peer(data.orgPeer):
					rtcPeer.get_peer(data.orgPeer).connection.set_remote_description("offer", data.data)
			
			if data.message == Message.answer:
				if rtcPeer.has_peer(data.orgPeer):
					rtcPeer.get_peer(data.orgPeer).connection.set_remote_description("answer", data.data)
#			if data.message == Message.serverLobbyInfo:
#
#				$LobbyBrowser.InstanceLobbyInfo(data.name,data.userCount)
	pass

func connected(id):
	print("New ID, webrtc")
	rtcPeer.create_mesh(id)
	multiplayer.multiplayer_peer = rtcPeer

#web rtc connection
func createPeer(id):
	if id != self.id:
		var peer : WebRTCPeerConnection = WebRTCPeerConnection.new()
		peer.initialize({
			"iceServers" : [{ "urls": ["stun:stun.l.google.com:19302"] }]
		})
		print("binding id " + str(id) + "my id is " + str(self.id))
		
		peer.session_description_created.connect(self.offerCreated.bind(id))
		peer.ice_candidate_created.connect(self.iceCandidateCreated.bind(id))
		rtcPeer.add_peer(peer, id)
		if !hostId == self.id:
			peer.create_offer()
		
		pass
		

func offerCreated(type, data, id):
	if !rtcPeer.has_peer(id):
		return
		
	rtcPeer.get_peer(id).connection.set_local_description(type, data)
	
	if type == "offer":
		sendOffer(id, data)
	else:
		sendAnswer(id, data)
	pass
	
	
func sendOffer(id, data):
	var message = {
		"peer" : id,
		"orgPeer" : self.id,
		"message" : Message.offer,
		"data": data,
		"Lobby": lobbyValue
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	pass

func sendAnswer(id, data):
	var message = {
		"peer" : id,
		"orgPeer" : self.id,
		"message" : Message.answer,
		"data": data,
		"Lobby": lobbyValue
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	pass

func iceCandidateCreated(midName, indexName, sdpName, id):
	var message = {
		"peer" : id,
		"orgPeer" : self.id,
		"message" : Message.candidate,
		"mid": midName,
		"index": indexName,
		"sdp": sdpName,
		"Lobby": lobbyValue
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	pass

#Connect to websocket server
func connectToServer(ip):
	peer.create_client("ws://127.0.0.1:8915")
	print("started client")


func _on_start_round_button_down():
	StartGame.rpc()
	pass # Replace with function body.

#@rpc("any_peer", "call_local")
func StartGame():
	print("Start Game")
	var message = {
		"message": Message.removeLobby,
		"lobbyID" : lobbyValue
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	start.emit()

func _on_join_lobby_button_down():
	join_lobby("")
	
func join_lobby(lobby_id:String):
	#loading_lobby.emit(true)
	connectToServer("")
	await get_tree().create_timer(0.5).timeout
	var message ={
		"id" : id,
		"message" : Message.lobby,
		"name" : "",
		"lobbyValue" : lobby_id,
		"type":"join"
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	#TODO: Consider... What if failed to create lobby?
	#if lobby_id == "":
		#GameManager.is_host=true
	pass # Replace with function body.	

func update_host(new_id:int):
	if hostId != new_id:
		hostId = new_id
		if id == hostId:
			GameManager.is_host=true
		else:
			GameManager.is_host=false
		host_changed.emit(new_id)

func leave_lobby():
	
	var message ={
		"id" : id,
		"message" : Message.lobby,
		"name" : "",
		"lobbyValue" : lobbyValue,
		"type":"leave"
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	await get_tree().create_timer(0.5).timeout
	print("Disconnected peer with id: ",id)
	multiplayer.disconnect_peer(id)
	var peers = rtcPeer.get_peers()
	for peer in peers:
		rtcPeer.remove_peer(peer)
	
	
	
