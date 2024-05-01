extends Node

var players = {}

var alive_players:Array[PlayerManager] =[]
enum game_states{PLAYING,SELECTING}
var state = game_states.SELECTING
var skin_deck:Deck

signal round_end

func _process(delta):
	if state==game_states.PLAYING and alive_players.size() == 1:
		end_round()

@rpc("any_peer","call_local")
func end_round():
	round_end.emit()
	alive_players.clear()
