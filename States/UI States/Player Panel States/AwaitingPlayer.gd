extends State
class_name AwaitingPlayer



func enter():
	
	%AwaitPlayer.visible=true
	$"../..".now_ready=true
	$"../..".active_panel=%AwaitPlayer
	

func exit():
	%AwaitPlayer.visible=false
	$"../..".now_ready=false
	

func _on_await_player_next():
	Transition.emit(self,"SelectSkin")
	
