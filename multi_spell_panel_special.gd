extends Node

func _on_multi_spell_select_exit() -> void:
	$"../VBoxContainer/Displays/Multi Spell Select".unlearn($"../VBoxContainer/Displays/NewSpell".center_card)
	

#func _on_multi_spell_panel_player_joined(index: int) -> void:
	#GameManager.reset_player_selections(index)
