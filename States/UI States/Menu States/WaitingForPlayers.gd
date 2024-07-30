extends State
class_name WaitingForPlayers



func enter():
	%"Waiting For Connect".visible=true
	
func exit():
	%"Waiting For Connect".visible=false
	
func _on_client_start():
	Transition.emit(self,"PlayerSelect")
	%SelectNoise.play()


func _on_client_peer_joined():
	%NumPlayers.text=str(GameManager.peers.size())
	%SelectNoise.play()


func _on_back_2_button_down():
	Transition.emit(self,"OnlineMatchmaking")
	%BackNoise.play()
