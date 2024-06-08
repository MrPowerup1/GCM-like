extends State
class_name SelectSpell2


func enter():
	$"../..".active_panel=%SpellSelect2
	%SpellSelect2.visible=true
	%SpellSelect2.transition_display_mode(CardSelectPanel.display_mode.SELECTING)
	%SpellSelect2.refresh()

func exit():
	%SpellSelect2.visible=false
	%SpellSelect2.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
	%SpellSelect2.refresh()

func _on_spell_select_2_exit():
	$"../..".unselect(%SpellSelect1)
	Transition.emit(self,"SelectSpell")

func _on_spell_select_2_next():
	$"../..".select(%SpellSelect2)
	Transition.emit(self,"Ready")
