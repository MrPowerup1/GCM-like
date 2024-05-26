extends State
class_name EndScreen


	
func enter():
	%EndGamePanel.visible=true
	%EndGamePanel.end()
	GameManager.alive_players.clear()

func exit():
	%EndGamePanel.visible=false


func _on_restart_button_down():
	Transition.emit(self,"PlayerSelect")


func _on_end_button_down():
	Transition.emit(self,"LocalOrOnline")
	
