extends State
##UNFOCUSED - CARD SELECT
signal unselect
func enter():
	#OVERALL VISIBILITY
	#$"../..".visible=false
	#BUTTON VISIBILITY: FALSE
	%LeftButton.visible=false
	%RightButton.visible=false
	%SelectButton.visible=false
	#CARD VISIBILITY TRUE and equal o o o 
	%LeftCard.set_display_style(CardDisplay.DisplayStyle.INVISIBLE)
	%CenterCard.set_display_style(CardDisplay.DisplayStyle.TINY)
	%RightCard.set_display_style( CardDisplay.DisplayStyle.INVISIBLE)
	%CenterCard.set_mode(CardDisplay.Mode.SELECTED)
	$"../..".theme_type_variation ="ClearPanelContainer"
	%NameBox.visible=false
	%TitleBox.visible=false
func exit():
	%LeftButton.visible=true
	%RightButton.visible=true
	%SelectButton.visible=true
	%CenterCard.set_mode(CardDisplay.Mode.CLEAR)
	$"../..".theme_type_variation ="Panel2"
	#%SkinSelect.visible=false
	#%SkinSelect.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
	#%SkinSelect.refresh()
	
func back():
	unselect.emit()
	Transition.emit(self,"Focused")


func _on_card_select_back_mode():
	if %StateManager.current_state==self:
		back()

#TODO:
func _on_card_select_focus():
	if %StateManager.current_state==self:
		back()
