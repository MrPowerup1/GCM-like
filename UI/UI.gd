extends CanvasLayer

#var player_select_screen:PlayerSelectScreen

func update_lobby_id(new_id:String):
	%"Waiting For Connect".set_lobby_id(new_id)




func _on_player_join_player_joined(new_player, index):
	%PlayerSelectScreen.player_join(new_player,index)

func start():
	%"Start Anim".play_start_animation()
