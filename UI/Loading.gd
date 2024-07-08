extends State
class_name Loading

func enter():
	%Loading.visible = true

func exit():
	%Loading.visible = false

	
func _on_client_wait_for_peers():
	Transition.emit(self,"WaitingForPlayers")


func _on_client_loading_lobby(state):
	if state == false:
		Transition.emit(self,"WaitingForPlayers")



func _on_client_failed_to_load_lobby(lobby_id):
	%"Lobby ID".text = lobby_id
	Transition.emit(self,"FailedToLoad")
