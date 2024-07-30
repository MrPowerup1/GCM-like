extends Node



func start_players():
	print("Starting players")
	var players = get_children()
	for player in players:
		player.start_round()
