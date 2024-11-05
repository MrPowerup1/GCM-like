extends State

##SELECTING

func enter():
	%Grey.visible = true
	%DoneButton.visible = false

func exit():
	%Grey.visible = false
	%DoneButton.visible = true
	

func _on_multi_spell_select_to_hovering() -> void:
	Transition.emit(self,"Hovering")
