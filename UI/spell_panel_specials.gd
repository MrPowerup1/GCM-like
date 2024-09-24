extends Node




func _on_new_spell_panel_player_joined(index: int) -> void:
	GameManager.reset_player_selections(index)
