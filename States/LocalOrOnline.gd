extends State
class_name LocalOrOnline

func enter():
	%SelectionUI.visible=true
	%LocalOrOnline.visible=true
	SyncManager.clear_peers()

func exit():
	%LocalOrOnline.visible=false


func _on_local_button_down():
	Transition.emit(self,"PlayerSelect")
	print("local")


func _on_online_button_down():
	Transition.emit(self,"OnlineMatchmaking")
