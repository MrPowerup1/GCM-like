extends CanvasLayer

#var player_select_screen:PlayerSelectScreen

enum state {HOST_GAME,PLAYERS_JOINING,PLAYERS_READY,PLAYER_SELECT,END_GAME}

signal start_round()

func _ready():
	GameManager.round_end.connect(_on_round_end)
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
		%PlayerSelectScreen.reset_panels()
		%SelectionUI.visible=true
		%PlayerJoin.searching=true
		%"Matchmaking Menu".visible=false
		%"Waiting For Connect".visible=false
		%"Player Select Menu".visible=true
		%StartGamePanel.visible=false
		%EndGamePanel.visible=false
	
	elif new_state==state.PLAYERS_READY:
		%StartGamePanel.visible=true
	
	elif new_state==state.END_GAME:
		%EndGamePanel.visible=true
		%EndGamePanel.end()
	
	
func _on_player_select_screen_players_ready():
	transition_state(state.PLAYERS_READY)
	%StartGamePanel.start_countdown()
	
func _on_player_select_screen_players_unready():
	transition_state(state.PLAYER_SELECT)
	%StartGamePanel.stop_countdown()

func _on_start_game_panel_start_round():
	start_round.emit()
	%StartGamePanel.stop_countdown()
	%SelectionUI.visible=false
	GameManager.state=GameManager.game_states.PLAYING

func _on_multiplayer_wait_for_players():
	transition_state(state.PLAYERS_JOINING)


func _on_multiplayer_player_joined():
	update_player_count.rpc()

@rpc("any_peer","call_local")
func update_player_count():
	%NumPlayers.text=str(GameManager.players.size())

func update_lobby_id(new_id:String):
	%LobbyID.text=new_id

func _on_start_round_button_down():
	start.rpc()

@rpc("any_peer","call_local")
func start():
	transition_state(state.PLAYER_SELECT)



func _on_restart_button_down():
	start.rpc()

func _on_round_end():
	transition_state(state.END_GAME)
	GameManager.state=GameManager.game_states.SELECTING


func _on_local_button_down():
	start()
