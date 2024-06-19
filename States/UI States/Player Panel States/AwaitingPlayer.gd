extends State
class_name AwaitingPlayer



func enter():
	
	%AwaitPlayer.visible=true
	$"../..".now_ready=true
	$"../..".active_panel=%AwaitPlayer
	$"../..".quit()

func exit():
	%AwaitPlayer.visible=false
	$"../..".now_ready=false
	

func _on_await_player_next():
	print("Shouldn't Be here")
	


func _on_player_panel_player_joined():
	Transition.emit(self,"SelectSkin")
