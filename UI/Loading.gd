extends State
class_name Loading

@export var timer:Timer

func enter():
	%Loading.visible = true
	timer.start()

func exit():
	%Loading.visible = false
	timer.stop()


func _on_client_loading_lobby(state):
	if state == false:
		Transition.emit(self,"WaitingForPlayers")



func _on_client_failed_to_load_lobby(lobby_id):
	%"Lobby ID".text = lobby_id
	Transition.emit(self,"FailedToLoad")


func _on_max_load_time_timeout():
	%"Lobby ID".text = "Failed to Connect to Server TIMEOUT"
	Transition.emit(self,"FailedToLoad")
