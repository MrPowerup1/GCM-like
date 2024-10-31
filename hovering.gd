extends State

##HOVERING

func enter():
	var current_focus = $"../..".focus
	$"../..".hovering = true
	%CardSelect.visible = false

func exit():
	$"../..".hovering = false
	

func _on_multi_spell_select_to_selecting() -> void:
	Transition.emit(self,"Selecting")
