extends Node

var players = {}

var alive_players:Array[PlayerManager] =[]
enum game_states{PLAYING,SELECTING}
var state = game_states.SELECTING
var skin_deck:Deck

signal round_end

func _process(delta):
	if state==game_states.PLAYING and alive_players.size() == 1:
		round_end.emit()
		alive_players.clear()
