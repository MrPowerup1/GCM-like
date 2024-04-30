extends CanvasLayer

#var player_select_screen:PlayerSelectScreen

enum state {HOST_GAME,PLAYERS_JOINING,PLAYERS_READY,PLAYER_SELECT}

signal start_round()

func _ready():
	pass
func add_player(player:PlayerManager):
		%PlayerSelectScreen.player_join(player)

func transition_state(new_state:state):
	if new_state==state.HOST_GAME:
		%"Matchmaking Menu".visible=true
		%"Waiting For Connect".visible=false
		%"Player Select Menu".visible=false
	elif new_state==state.PLAYERS_JOINING:
		%PlayerJoin.searching=false
		%"Matchmaking Menu".visible=false
		%"Waiting For Connect".visible=true
		%StartGamePanel.visible=false
	elif  new_state==state.PLAYER_SELECT:
		%PlayerJoin.searching=true
		%"Matchmaking Menu".visible=false
		%"Waiting For Connect".visible=false
		%"Player Select Menu".visible=true
		%StartGamePanel.visible=false
	elif new_state==state.PLAYERS_READY:
		%StartGamePanel.visible=true
	
	
func _on_player_select_screen_players_ready():
	transition_state(state.PLAYERS_READY)
	%StartGamePanel.start_countdown()
	
func _on_player_select_screen_players_unready():
	transition_state(state.PLAYER_SELECT)
	%StartGamePanel.stop_countdown()

func _on_start_game_panel_start_round():
	start_round.emit()
	%StartGamePanel.stop_countdown()
	visible=false

func _on_multiplayer_wait_for_players():
	transition_state(state.PLAYERS_JOINING)


func _on_multiplayer_player_joined():
	update_player_count.rpc()

@rpc("any_peer","call_local")
func update_player_count():
	%NumPlayers.text=str(str(%NumPlayers.text).to_int()+1)


func _on_start_round_button_down():
	start.rpc()

@rpc("any_peer","call_local")
func start():
	transition_state(state.PLAYER_SELECT)
