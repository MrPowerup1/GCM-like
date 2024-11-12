extends State

##SELECTING

func enter():
	%Grey.visible = true
	%CardSelect.visible = true
	%CardSelect.focused()
	$"../..".hovering = false
	%"Spell Axis".set_display_style(CardDisplay.DisplayStyle.TINY)
	%DoneButton.visible = false

func exit():
	%"Spell Axis".set_display_style(CardDisplay.DisplayStyle.HOVERING)
	$"../..".hovering = false
	%Grey.visible = false
	%CardSelect.visible = false
	%DoneButton.visible = true
	

func _on_multi_spell_select_to_hovering() -> void:
	Transition.emit(self,"Hovering")
