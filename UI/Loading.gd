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
	%FailedToLoad.set_lobby_id(lobby_id)
	Transition.emit(self,"FailedToLoad")


func _on_max_load_time_timeout():
	%FailedToLoad.set_lobby_id("Failed to Connect to Server TIMEOUT")
	Transition.emit(self,"FailedToLoad")
