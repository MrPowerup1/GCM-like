extends Node2D
class_name Match



const LOG_FILE_DIRECTORY = 'user://detailed_logs'


var logging_enabled:bool = true

signal start_round()

func _ready():
	SyncManager.sync_started.connect(_on_SyncManager_sync_started)
	SyncManager.sync_stopped.connect(_on_SyncManager_sync_stopped)
	SyncManager.sync_lost.connect(_on_SyncManager_sync_lost)
	SyncManager.sync_regained.connect(_on_SyncManager_sync_regained)
	GameManager.added_player.connect(on_GameManager_add_player)

#FROM PLAYER JOIN: func add_player(local_id:int, input:Input_Keys):

func on_GameManager_add_player(player:PlayerManager):
	$Players.add_child(player)

func load_players(player_data:Dictionary):
	GameManager.players = player_data.duplicate()
	for player_id in player_data:
		print("Player number ", player_id)
		var new_player = GameManager.add_player(-1,null,player_data[player_id])
		print(new_player)
		%Players.add_child(new_player)
		print(%Players.get_child_count())

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
		SyncManager.start_logging(LOG_FILE_DIRECTORY+ '/' + log_file_name,match_info)

func _on_SyncManager_sync_stopped():
	SyncManager.stop_logging()

func _on_SyncManager_sync_lost():
	print("Lost Sync")

func _on_SyncManager_sync_regained():
	print("Regained Sync")

func setup_match_for_replay(my_peer_id:int,peer_ids: Array,match_info:Dictionary)-> void:
	print("We're setting it up now")
	$UI.visible=false
	load_players(match_info.get("players"))
	start_match()

func start_match():
	var player_count = $Players.get_child_count()
	print("Player count",player_count)
	print ($Players.get_children())
	var positions = $"Basic Level".get_starting_positions(player_count)
	for i in range(player_count):
		var player=$Players.get_child(i)
		player.spawn_loc=positions[i]
		player.player_character.fixed_position=positions[i]
