extends State
class_name UserDisconnect

func enter():
	%UserDisconnect.visible = true

func exit():
	%UserDisconnect.visible = false


func _on_back_3_button_down():
	Transition.emit(self,"LocalOrOnline")
