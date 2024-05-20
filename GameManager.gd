extends Node

var player_scene:PackedScene = load("res://PlayerManager.tscn")


#Info about all the players
var players = {}

#This doesn't do much right now, just holds player unique ids (It's never checked or used during the game)
var peers = {}

var alive_players:Array[PlayerManager] =[]

#Sync the skin deck selection for all players
var universal_skin_deck:Deck = load("res://TestSkinDeck.tres")

var universal_spell_deck:Deck = load("res://TestSpellDeck.tres")

#Just used to ensure one time activations
var is_host:bool = false

#FROM PLAYER JOIN: func add_player(local_id:int, input:Input_Keys):
func add_player() -> PlayerManager:
	var new_player = player_scene.instantiate()
	var multiplayer_id = multiplayer.get_unique_id()
	var unique_player_index = players.size()
	new_player.player_index = unique_player_index
	players [unique_player_index] = {
			"player_data": {
				#
				"known_spells": [0,1,2],
				"selected_skin": 0
			},
			"match_data": {
				#TODO: FIX Garbage Data
				"selected_spells":[0,1],
			}
		}
	return new_player

#TODO: Implement for replay feature
func load_players(player_data:Dictionary) -> Array[PlayerManager]:
	
	
	return []
