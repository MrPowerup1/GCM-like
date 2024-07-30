extends State
class_name FailedToLoad

func enter():
	%FailedToLoad.visible = true

func exit():
	%FailedToLoad.visible = false


func _on_back_3_button_down():
	Transition.emit(self,"OnlineMatchmaking")
	%BackNoise.play()
