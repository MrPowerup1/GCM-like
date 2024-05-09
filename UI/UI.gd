extends CanvasLayer

#var player_select_screen:PlayerSelectScreen


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
	pass

func _on_SyncManager_sync_stopped():
	pass

func _on_SyncManager_sync_lost():
	print("Lost Sync")

func _on_SyncManager_sync_regained():
	print("Regained Sync")
