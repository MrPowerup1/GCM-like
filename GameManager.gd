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
			"local":false,
			"peer_id": -1,
			"input_keys":base_input,
			"known_spells": [0,1,2],
			"selected_skin": 0,
			"selected_spells":[],
			"selected_level":-1
		}


#Just used to ensure one time activations
var is_host:bool = false


class PlayerData:
	var peer_id:int
	var name: String
	#Unique among all peer instances
	var index: int
	var input:Input_Keys
	var known_spells:Array[int]
	var selected_skin:int
	var selected_spells:Array[int]
	#TODO: this should be implemented
	#var selected_level:int
	
	func _init(_peer_id:int,_name:String,_index:int,_input:Input_Keys=null
	,_known_spells:Array[int]=[0,1,2],_selected_skin:int=0,_selected_spells:Array[int]=[0,1]):
		peer_id=_peer_id
		index=_index
		input=_input
		known_spells=_known_spells
		selected_skin=_selected_skin
		selected_spells=_selected_spells
	
	static func from_dict(data:Dictionary)->PlayerData:
		return PlayerData.new(data['peer_id'],data['name'],data['index'],data['input'],data['known_spells'],data['selected_skin'],data['selected_spells'])
		
	func to_dict() -> Dictionary:
		return {
			peer_id=peer_id,
			index=index,
			input=input,
			known_spells=known_spells,
			selected_skin=selected_skin,
			selected_spells=selected_spells,
		}


#func oldadd_player(client_id:int=-1,input:Input_Keys = null,player_data:Dictionary=default_player_dict):
	#print("Added player")
	#var new_player = player_scene.instantiate()
	#var unique_player_index = get_player_id()
	#new_player.name="PlayerManager" + str(unique_player_index)
	#new_player.player_index = unique_player_index
	#GameManager.players [unique_player_index] = player_data
	#new_player.from_dict(player_data)
	#added_player.emit(new_player)
	#get_node("/root/Match/Players").add_child(new_player)
	#print (get_node("/root/Match/Players").get_child_count())
	#if input!=null:
		#new_player.add_controls(input)
	#if client_id!=-1:
		#new_player.device_id=client_id
	#players[unique_player_index]['player_data']['client_id']=client_id
	#return new_player

func add_player(peer_id:int,input:Input_Keys):
	var player_index = get_player_id()
	players[player_index] = default_player_dict
	players[player_index]['peer_id']=peer_id
	if peer_id == multiplayer.get_unique_id():
		players[player_index]['local']=true
	else:
		players[player_index]['local']=false
	players[player_index]['input']=input
	return player_index

func load_player(player_data:Dictionary):
	players[get_player_id()]=player_data


func get_player_id()->int:
	for i in range(100):
		if not players.has(i):
			return i
	printerr("Out of bounds of player count for player ID")
	return -1

func get_players_on_peer(peer_id:int)->Array[int]:
	var to_return = []
	for player in players:
		if player['peer_id']==peer_id:
			to_return.append(players.find_key(player))
	return to_return
