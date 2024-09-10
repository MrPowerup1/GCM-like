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
	%CenterCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
	%RightCard.set_display_style( CardDisplay.DisplayStyle.TINY)
	%NameBox.visible=true

func exit():
	$"../..".can_select_left_right = false

	

#TODO: WHICH SIGNAL TRIGGERS THIS
func next():
	Transition.emit(self,"Zoomed")

func back():
	unfocus.emit()
	Transition.emit(self,"Unfocused")


func _on_card_select_back_mode():
	back()


func _on_card_select_next_mode():
	next()
