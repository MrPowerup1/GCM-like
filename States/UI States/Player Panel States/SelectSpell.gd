extends State
class_name SelectSpell




		
func enter():
	$"../..".active_panel=%SpellSelect1
	%SpellSelect1.visible=true
	%SpellSelect1.transition_display_mode(CardSelectPanel.display_mode.SELECTING)
	%SpellSelect1.refresh()

func exit():
	%SpellSelect1.visible=false
	%SpellSelect1.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
	%SpellSelect1.refresh()

func _on_spell_select_1_exit():
	$"../..".unselect(%SkinSelect)
	Transition.emit(self,"SelectSkin")

func _on_spell_select_1_next():
	$"../..".select(%SpellSelect1)
	Transition.emit(self,"SelectSpell2")
