extends State
##FOCUSED - CARD SELECT	
signal unfocus

func enter():
	$"../..".visible=true
	$"../..".can_select_left_right = true
	%LeftButton.visible=true
	%SelectButton.visible=true
	%RightButton.visible=true
	%LeftCard.set_display_style(CardDisplay.DisplayStyle.TINY)
	%LeftCard.set_mode(CardDisplay.Mode.GREY)
	%CenterCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
	%RightCard.set_display_style( CardDisplay.DisplayStyle.TINY)
	%RightCard.set_mode(CardDisplay.Mode.GREY)
	%NameBox.visible=true
	%TitleBox.visible=true

func exit():
	$"../..".can_select_left_right = false
	%LeftCard.set_mode(CardDisplay.Mode.CLEAR)
	%RightCard.set_mode(CardDisplay.Mode.CLEAR)
	

#TODO: WHICH SIGNAL TRIGGERS THIS
func next():
	Transition.emit(self,"Zoomed")

func back():
	unfocus.emit()
	Transition.emit(self,"Unfocused")


func _on_card_select_back_mode():
	if %StateManager.current_state==self:
		back()


func _on_card_select_next_mode():
	if %StateManager.current_state==self:
		next()
