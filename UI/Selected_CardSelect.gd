extends State
##UNFOCUSED - CARD SELECT
signal unselect
func enter():
	#OVERALL VISIBILITY
	$"../..".visible=false
	#BUTTON VISIBILITY: FALSE
	%LeftButton.visible=false
	%RightButton.visible=false
	%SelectButton.visible=false
	#CARD VISIBILITY TRUE and equal o o o 
	%LeftCard.set_display_style(CardDisplay.DisplayStyle.INVISIBLE)
	%CenterCard.set_display_style(CardDisplay.DisplayStyle.TINY)
	%RightCard.set_display_style( CardDisplay.DisplayStyle.INVISIBLE)	
	%NameBox.visible=true
#func exit():
	#%SkinSelect.visible=false
	#%SkinSelect.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
	#%SkinSelect.refresh()
	

#TODO: WHICH SIGNAL TRIGGERS THIS
func back():
	unselect.emit()
	Transition.emit(self,"Focused")


func _on_card_select_back_mode():
	back()


func _on_card_select_focus():
	back()
