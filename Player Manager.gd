extends Node

func start_players():
	var players = get_children()
	for player in players:
		player.start_round()
