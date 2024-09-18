extends State
class_name PlayerSelect



func enter():
	%SelectionUI.visible=true
	%"Player Select Menu".visible=true
	#%PlayerSelectScreen.reset_panels()

func exit():
	%"Player Select Menu".visible=false
	
func _on_player_select_screen_players_ready():
	Transition.emit(self,"RoundStarting")
	%SelectNoise.play()


func _on_client_peer_disconnect(id):
	%"User ID".text = str(id)
	Transition.emit(self,"UserDisconnect")

#TODO: Only local disconnect for now
func _on_back_button_down() -> void:
	%Client.leave_lobby()
	Transition.emit(self,"LocalOrOnline")
	%BackNoise.play()
