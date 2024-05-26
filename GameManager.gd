extends Node




#Info about all the players
var players = {}

#TODO: Delete? This doesn't do much right now, just holds player unique ids (It's never checked or used during the game)
var peers = {}

var alive_players:Array[PlayerManager] =[]

#Sync the skin deck selection for all players
var universal_skin_deck:Deck = load("res://TestSkinDeck.tres")

var universal_spell_deck:Deck = load("res://TestSpellDeck.tres")

var universal_level_deck:Deck = load("res://TestLevelDeck.tres")
var temporary_level:PackedScene = load("res://Basic_Level.tscn")
var player_scene:PackedScene = load("res://PlayerManager.tscn")

var base_input = preload("res://Inputs/Base Input.tres").to_dict()

var default_player_dict = {
			"player_data": {
				"client_id": -1,
				"input_keys":base_input,
				"known_spells": [0,1,2],
				"selected_skin": 0
			},
			"match_data": {
				#TODO: FIX Garbage Data
				"selected_spells":[0,1],
				"selected_level":[0]
			}
		}


#Just used to ensure one time activations
var is_host:bool = false

signal added_player(player:PlayerManager)

func add_player(client_id:int=-1,input:Input_Keys = null,player_data:Dictionary=default_player_dict):
	print("Added player")
	var new_player = player_scene.instantiate()
	var unique_player_index = get_player_id()
	new_player.name="PlayerManager" + str(unique_player_index)
	new_player.player_index = unique_player_index
	GameManager.players [unique_player_index] = player_data
	new_player.from_dict(player_data)
	added_player.emit(new_player)
	get_node("/root/Match/Players").add_child(new_player)
	print (get_node("/root/Match/Players").get_child_count())
	if input!=null:
		new_player.add_controls(input)
	if client_id!=-1:
		new_player.device_id=client_id
	players[unique_player_index]['player_data']['client_id']=client_id
	return new_player

func get_player_id()->int:
	for i in range(100):
		if not players.has(i):
			return i
	printerr("Out of bounds of player count for player ID")
	return -1
