extends Node



#General info about players indexed by player index
var players = {}

#input keys dictionaries indexed by player index
var local_players = {}

#indexed by multiplayer unique id, status
var peers = {}

#indexed by player index, only holds which players are alive (a little barebones, could it go somewehere else?)
var alive_players = {}

#Sync the skin deck selection for all players
var universal_skin_deck:Deck = load("res://TestSkinDeck.tres")

var universal_spell_deck:Deck = load("res://TestSpellDeck.tres")

var universal_level_deck:Deck = load("res://TestLevelDeck.tres")
var temporary_level:PackedScene = load("res://Basic_Level.tscn")

var select_sound:AudioStreamWAV

var base_input = preload("res://Inputs/Base Input.tres").to_dict()

var default_player_dict = {
			"peer_id": -1,
			"player_index":-1,
			"known_spells": [0,1,2],  #range(universal_spell_deck.cards.size()),
			"selected_skin": 0,
			"selected_spells":[],
			"selected_level":-1,
			"wins":0
		}

var default_local_player_dict = {
	'input_keys':base_input
}

#Just used to ensure one time activations
var is_host:bool = false

#TODO: This is unused... why does Snopek use it?
class PlayerData:
	var peer_id:int
	var name: String
	#Unique among all peer instances
	var index: int
	var input:Input_Keys
	var known_spells:Array[int]
	var selected_skin:int
	var selected_spells:Array[int]
	var wins:int = 0
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

func add_player(peer_id:int,input:Input_Keys)->int:
	var player_index = get_player_id()
	players[player_index] = default_player_dict.duplicate(true)
	players[player_index]['peer_id']=peer_id
	players[player_index]['player_index']=player_index
	if peer_id==multiplayer.get_unique_id():
		local_players[player_index] = {
			'input_keys':input.to_dict()
		}
	print("New player at index, ",player_index," Has data ",players[player_index])
	update_spell_deck(player_index)
	for old_player_index in players:
		if old_player_index!=player_index:
			print("old player at index, ",old_player_index," Has data ",players[old_player_index])
	return player_index

func load_player(player_data:Dictionary):
	#HACK: assumes players in dictionary are sorted
	players[get_player_id()]=player_data
		 

func remove_player(player_index:int) -> bool:
	if players.has(player_index):
		players.erase(player_index)
		if local_players.has(player_index):
			local_players.erase(player_index)
		print("Removed player. player count is ",players.size())
		return true
	return false

#func player_learn_spell(player_index:int,spell_index:int):
	#pass

func update_spell_deck(player_index:int):
	assert(players.has(player_index),"Updating spell of missing player index")
	players[player_index]['known_spells_deck'] = universal_spell_deck.subdeck(players[player_index]['known_spells'])

func get_player_id()->int:
	print("Current keys ",players.keys())
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
	
func check_sync()-> bool:
	for peer in peers.values():
		if !peer.get('synced'):
			return false
	return true

func update_sync(peer_id:int,is_synced:bool):
	if peer_id !=1:
		peers[str(peer_id)]['synced'] = is_synced

func reset_decks():
	universal_level_deck.reset()
	universal_skin_deck.reset()
	universal_spell_deck.reset()

func reset_player_selections(index:int):
	assert(players.has(index),"Attempting to reset missing player index")
	players[index]['selected_spells'].clear()
		

func get_most_wins_index() -> Array[int]:
	var max = 0
	var max_indices:Array[int]
	for index in players.keys():
		if players[index]['wins'] > max:
			max = players[index]['wins']
			max_indices.clear()
			max_indices.append(index)
		elif players[index]['wins'] == max:
			max_indices.append(index)
	return max_indices
