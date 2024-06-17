extends Node2D
class_name Match



const LOG_FILE_DIRECTORY = 'user://detailed_logs'

@export var player_scene:PackedScene

var logging_enabled:bool = true

signal start_round()

func _ready():
	SyncManager.sync_started.connect(_on_SyncManager_sync_started)
	SyncManager.sync_stopped.connect(_on_SyncManager_sync_stopped)
	SyncManager.sync_lost.connect(_on_SyncManager_sync_lost)
	SyncManager.sync_regained.connect(_on_SyncManager_sync_regained)
	#HACK: Just a test method
	#SyncManager.scene_spawned.connect(_test_method)
	#SyncManager.scene_despawned.connect(_test_method_2)
	
#func _test_method(name: String, spawned_node: Node, scene: PackedScene, data: Dictionary):
	#print("Scene spawned")
	#print(name)
	#print(spawned_node)
	#print(scene)
	##print(data)
	#print(SyncManager._spawn_manager.spawn_records)
#
#func _test_method_2(name: String, node: Node):
	#print("Scene despawned")
	#print(name)
	#print(node)
	#print(SyncManager._spawn_manager.spawn_records)

func load_players(player_data:Dictionary):
	for player_id in player_data:
		#print("Player number ", player_id)
		var new_player = GameManager.load_player(player_data[player_id])
		#print(new_player)
		%Players.add_child(new_player)
		#print(%Players.get_child_count())

func _on_SyncManager_sync_started():
	start_match()
	if logging_enabled and not SyncReplay.active:
		var dir=DirAccess.open(LOG_FILE_DIRECTORY)
		if not dir:
			dir=DirAccess.make_dir_absolute(LOG_FILE_DIRECTORY)
		var datetime = Time.get_datetime_dict_from_system(true)
		var log_file_name = "%04d%02d%02d-%02d%02d%02d-peer-%d.log"%[
			datetime['year'],
			datetime['month'],
			datetime['day'],
			datetime['hour'],
			datetime['minute'],
			datetime['second'],
			multiplayer.get_unique_id(),
		]
		var match_info = {
			"player_count":GameManager.players.size(),
			"players":GameManager.players,
			#TODO:Add Functionality to level index
			"level_index":0
		}
		#print("------match info------")
		#print(match_info)
		SyncManager.start_logging(LOG_FILE_DIRECTORY+ '/' + log_file_name,match_info)

func _on_SyncManager_sync_stopped():
	SyncManager.stop_logging()

func _on_SyncManager_sync_lost():
	print("Lost Sync")
	pass

func _on_SyncManager_sync_regained():
	print("Regained Sync")
	pass

func setup_match_for_replay(my_peer_id:int,peer_ids: Array,match_info:Dictionary)-> void:
	#print("We're setting it up now")
	#print(match_info)
	$UI.visible=false
	load_players(match_info.get("players"))

func start_match():
	var player_count = GameManager.players.size()
	var players =GameManager.players.values()
	#print("Player count",player_count)
	var positions = $"Basic Level".get_starting_positions(player_count)
	for i in range(player_count):
		#print(i)
		var player_data = players[i]
		player_data['spawn_position_x']=positions[i].x
		player_data['spawn_position_y']=positions[i].y
		#print("Spawning player with data ",player_data)
		var new_player = SyncManager.spawn('Player',%Players,player_scene,player_data)
		
