extends Node



func start_players():
	print("Starting players")
	var players = get_children()
	print(players.size())
	for player in players:
		player.start_round()
