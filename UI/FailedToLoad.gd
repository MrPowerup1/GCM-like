extends State
class_name FailedToLoad

func enter():
	%FailedToLoad.visible = true

func exit():
	%FailedToLoad.visible = false

func _on_back_button_down() -> void:
	Transition.emit(self,"OnlineMatchmaking")
	%BackNoise.play()
