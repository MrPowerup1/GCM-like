extends MarginContainer

#var card_displays:Array[CardDisplay]
#
#func add_display(new_display:CardDisplay):
	#card_displays.append(new_display)

func set_display_style(new_style:CardDisplay.DisplayStyle):
	#for card_display in card_displays:
		#card_display.set_display_style(new_style)
	
	set_child_display_if_exists(%"Top Spell",new_style)
	set_child_display_if_exists(%"Bottom Spell",new_style)
	set_child_display_if_exists(%"Left Spell",new_style)
	set_child_display_if_exists(%"Right Spell",new_style)
	#%"Bottom Spell".get_child(0).set_display_style(new_style)
	#%"Left Spell".get_child(0).set_display_style(new_style)
	#%"Right Spell".get_child(0).set_display_style(new_style)

func set_child_display_if_exists(node,new_style:CardDisplay.DisplayStyle):
	if node.get_child_count() > 0:
		node.get_child(0).set_display_style(new_style)

func set_mode(new_mode:CardDisplay.Mode):
	#for card_display in card_displays:
		#card_display.set_mode(new_mode)
	set_child_mode_if_exists(%"Top Spell",new_mode)
	set_child_mode_if_exists(%"Bottom Spell",new_mode)
	set_child_mode_if_exists(%"Left Spell",new_mode)
	set_child_mode_if_exists(%"Right Spell",new_mode)
	#%"Top Spell".get_child(0).set_mode(new_mode)
	#%"Bottom Spell".get_child(0).set_mode(new_mode)
	#%"Left Spell".get_child(0).set_mode(new_mode)
	#%"Right Spell".get_child(0).set_mode(new_mode)
	
func set_child_mode_if_exists(node,new_mode:CardDisplay.Mode):
	if node.get_child_count() > 0:
		node.get_child(0).set_mode(new_mode)
