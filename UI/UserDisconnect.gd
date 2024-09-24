extends State
class_name UserDisconnect

func enter():
	%UserDisconnect.visible = true
	%BackNoise.play()

func exit():
	%UserDisconnect.visible = false


func _on_back_button_down() -> void:
	Transition.emit(self,"LocalOrOnline")
	%BackNoise.play()
