extends State
##UNFOCUSED - CARD SELECT	
func enter():
	#OVERALL VISIBILITY
	#$"../..".visible=true
	#BUTTON VISIBILITY: FALSE
	%LeftButton.visible=false
	%RightButton.visible=false
	%SelectButton.visible=false
	#CARD VISIBILITY TRUE and equal o o o 
	%LeftCard.set_display_style(CardDisplay.DisplayStyle.TINY)
	%CenterCard.set_display_style(CardDisplay.DisplayStyle.TINY)
	%RightCard.set_display_style( CardDisplay.DisplayStyle.TINY)
	%NameBox.visible=false
	%TitleBox.visible=false

func exit():
	pass
	#%SkinSelect.visible=false
	#%SkinSelect.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
	#%SkinSelect.refresh()
	

#TODO: WHICH SIGNAL TRIGGERS THIS
func next():
	Transition.emit(self,"Focused")


func _on_card_select_next_mode():
	if %StateManager.current_state==self:
		next()


func _on_card_select_focus():
	if %StateManager.current_state==self:
		next()
