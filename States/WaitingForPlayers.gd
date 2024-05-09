extends State
class_name WaitingForPlayers

func enter():
	%"Waiting For Connect".visible=true
	
func exit():
	%"Waiting For Connect".visible=false
	
func _on_client_start():
	Transition.emit(self,"PlayerSelect")
