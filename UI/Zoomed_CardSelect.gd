extends State
##ZOOMED - CARD SELECT
signal select
func enter():
	$"../..".visible=true
	%LeftButton.visible=false
	%SelectButton.visible=true
	%RightButton.visible=false
	%LeftCard.set_display_style(CardDisplay.DisplayStyle.INVISIBLE)
	%CenterCard.set_display_style(CardDisplay.DisplayStyle.ZOOMED)
	%RightCard.set_display_style( CardDisplay.DisplayStyle.INVISIBLE)
	%NameBox.visible=false
	%TitleBox.visible=false

#TODO: WHICH SIGNAL TRIGGERS THIS
func next():
	select.emit()
	Transition.emit(self,"Selected")

func back():
	Transition.emit(self,"Focused")


func _on_card_select_back_mode():
	if %StateManager.current_state==self:
		back()


func _on_card_select_next_mode():
	if %StateManager.current_state==self:
		next()
