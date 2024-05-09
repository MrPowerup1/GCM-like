extends State
class_name OnlineMatchmaking

func enter():
	%SelectionUI.visible=true
	%"Matchmaking Menu".visible=true

func exit():
	%"Matchmaking Menu".visible=false


func _on_client_wait_for_players():
	Transition.emit(self,"WaitingForPlayers")
