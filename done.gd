extends PanelContainer


func highlight(new_state:bool):
	if new_state:
		theme_type_variation = "Panel2"
	else:
		theme_type_variation = "ClearPanelContainer"
