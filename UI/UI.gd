extends CanvasLayer

#var player_select_screen:PlayerSelectScreen

func _ready():
	GameManager.added_player.connect(add_player)
	
func add_player(player:PlayerManager):
	%PlayerSelectScreen.player_join(player)
	$StateManager/RoundStarting.start_round.connect(player.start_round)

func update_lobby_id(new_id:String):
	%LobbyID.text=new_id


