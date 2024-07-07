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
