extends State
class_name RoundStarting

signal start_round

func enter():
	%"Player Select Menu".visible=true
	%StartGamePanel.visible=true
	%StartGamePanel.start_countdown()

func exit():
	%"Player Select Menu".visible=false
	%StartGamePanel.visible=false
	%StartGamePanel.stop_countdown()
	
func _on_start_game_panel_start_round():
	start_round.emit()
	Transition.emit(self,"RoundInProgress")

func _on_player_select_screen_players_unready():
	Transition.emit(self,"PlayerSelect")
