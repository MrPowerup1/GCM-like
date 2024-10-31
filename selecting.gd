extends State

##SELECTING

func enter():
	%Grey.visible = true
	%CardSelect.visible = true
	%CardSelect.focused()

func exit():
	%Grey.visible = false
	%CardSelect.visible = false
	

func _on_multi_spell_select_to_hovering() -> void:
	Transition.emit(self,"Hovering")
