extends State
class_name RoundStarting

signal start_round

func enter():
	%"Player Select Menu".visible=true
	%"Player Select Menu".start_countdown()

func exit():
	%"Player Select Menu".visible=false
	%"Player Select Menu".stop_countdown()
	
	

func _on_player_select_screen_players_unready():
	Transition.emit(self,"PlayerSelect")
	%BackNoise.play()


func _on_client_peer_disconnect(id):
	%UserDisconnect.set_user_id(str(id))
	Transition.emit(self,"UserDisconnect")


func _on_player_select_menu_start_game() -> void:
	start_round.emit()
	Transition.emit(self,"RoundInProgress")
