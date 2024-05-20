extends CanvasLayer

#var player_select_screen:PlayerSelectScreen

const LOG_FILE_DIRECTORY = 'user://detailed_logs'

var logging_enabled:bool = true

signal start_round()

func _ready():
	SyncManager.sync_started.connect(_on_SyncManager_sync_started)
	SyncManager.sync_stopped.connect(_on_SyncManager_sync_stopped)
	SyncManager.sync_lost.connect(_on_SyncManager_sync_lost)
	SyncManager.sync_regained.connect(_on_SyncManager_sync_regained)
	
func add_player(player:PlayerManager):
	%PlayerSelectScreen.player_join(player)

func update_lobby_id(new_id:String):
	%LobbyID.text=new_id

func _on_SyncManager_sync_started():
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
		SyncManager.start_logging(LOG_FILE_DIRECTORY+ '/' + log_file_name,{"PlayerCount":GameManager.players.size()})

func _on_SyncManager_sync_stopped():
	SyncManager.stop_logging()

func _on_SyncManager_sync_lost():
	print("Lost Sync")

func _on_SyncManager_sync_regained():
	print("Regained Sync")

func setup_match_for_replay(my_peer_id:int,peer_ids: Array,match_info:Dictionary)-> void:
	self.visible=false
