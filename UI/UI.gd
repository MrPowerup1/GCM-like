extends CanvasLayer

#var player_select_screen:PlayerSelectScreen

func update_lobby_id(new_id:String):
	%LobbyID.text=new_id




func _on_player_join_player_joined(new_player, index):
	%PlayerSelectScreen.player_join(new_player,index)

func start():
	%StartAnimator.play("Start Animation")
