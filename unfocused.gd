extends State

##UNFOCUSED

func enter():
	$"../..".hovering = false
	%DoneButton.visible=false
	%Grey.visible = true
	%"Spell Axis".set_display_style(CardDisplay.DisplayStyle.TINY)
	

func exit():
	%DoneButton.visible=true
	%Grey.visible = false
	%"Spell Axis".set_display_style(CardDisplay.DisplayStyle.HOVERING)


func _on_multi_spell_select_to_hovering() -> void:
	Transition.emit(self,"Hovering")
