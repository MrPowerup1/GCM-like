extends State
class_name OnlineMatchmaking

func enter():
	%SelectionUI.visible=true
	%"Matchmaking Menu".visible=true

func exit():
	%"Matchmaking Menu".visible=false

#No longer used	
func _on_client_wait_for_peers():
	Transition.emit(self,"WaitingForPlayers")

func _on_client_loading_lobby(state):
	if state==true:
		Transition.emit(self,"Loading")


func _on_back_button_down():
	Transition.emit(self,"LocalOrOnline")
