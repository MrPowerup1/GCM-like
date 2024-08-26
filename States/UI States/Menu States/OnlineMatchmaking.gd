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
	%SelectNoise.play()
	if state==true:
		Transition.emit(self,"Loading")


func _on_back_button_down():
	%BackNoise.play()
	Transition.emit(self,"LocalOrOnline")
