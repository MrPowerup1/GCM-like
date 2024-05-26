extends State
class_name PlayerSelect



func enter():
	%SelectionUI.visible=true
	%"Player Select Menu".visible=true
	%PlayerSelectScreen.reset_panels()
	%PlayerJoin.searching=true
	print("Entering Player Select")

func exit():
	%"Player Select Menu".visible=false
	%PlayerJoin.searching=true
	
func _on_player_select_screen_players_ready():
	Transition.emit(self,"RoundStarting")
