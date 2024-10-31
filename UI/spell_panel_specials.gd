extends Node




func _on_new_spell_panel_player_joined(index: int) -> void:
	GameManager.reset_player_selections(index)
	var player_deck = GameManager.universal_spell_deck.subdeck(GameManager.players[index].get('known_spells'))
	%SpellSelect1.load_deck(player_deck)
