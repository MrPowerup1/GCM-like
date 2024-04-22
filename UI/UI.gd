extends CanvasLayer

#var player_select_screen:PlayerSelectScreen

enum state {PLAYERS_JOINING,PLAYERS_READY,SPELL_SELECT}

signal start_round()

func _ready():
	pass
func add_player(player:PlayerManager):
		%PlayerSelectScreen.player_join(player)

func transition_state(new_state:state):
	if new_state==state.PLAYERS_READY:
		%StartGamePanel.visible=true
	elif  new_state==state.PLAYERS_JOINING:
		%StartGamePanel.visible=false



func _on_player_select_screen_players_ready():
	transition_state(state.PLAYERS_READY)
	%StartGamePanel.start_countdown()
	


func _on_player_select_screen_players_unready():
	transition_state(state.PLAYERS_JOINING)
	%StartGamePanel.stop_countdown()


func _on_start_game_panel_start_round():
	start_round.emit()
	%StartGamePanel.stop_countdown()
	visible=false
