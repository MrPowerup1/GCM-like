extends State
class_name SelectSkin



		
func enter():
	$"../..".active_panel=%SkinSelect
	%SkinSelect.visible=true
	%SkinSelect.transition_display_mode(CardSelectPanel.display_mode.SELECTING)
	%SkinSelect.refresh()

func exit():
	%SkinSelect.visible=false
	%SkinSelect.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
	%SkinSelect.refresh()
	


func _on_skin_select_exit():
	Transition.emit(self,"AwaitingPlayer")


func _on_skin_select_next():
	$"../..".select(%SkinSelect)
	Transition.emit(self,"SelectSpell")
