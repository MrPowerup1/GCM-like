extends CanvasLayer

@export var back_scene_path:String = "res://local_or_online.tscn"
@export var user_disconnect_scene:PackedScene
@export var next_scene:PackedScene

signal players_ready
signal players_unready
signal back
signal start_round
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	Client.peer_disconnect.connect(disconnected)
	GameManager.reset_decks()
	
func _on_players_ready() -> void:
	unsync.rpc()
	%StartRoundPanel.start_countdown()

func _on_players_unready() -> void:
	sync.rpc()
	%StartRoundPanel.stop_countdown()

@rpc("any_peer","call_local")
func unsync():
	GameManager.update_sync(multiplayer.get_remote_sender_id(),false)

@rpc("any_peer","call_local")
func sync():
	GameManager.update_sync(multiplayer.get_remote_sender_id(),true)

func _on_back_button_down() -> void:
	#back.emit()
	Client.leave_lobby()
	get_tree().change_scene_to_file(back_scene_path)

func _on_start_game_panel_start_round() -> void:
	get_tree().change_scene_to_packed(next_scene)

func start_countdown():
	%StartRoundPanel.start_countdown()

func stop_countdown():
	%StartRoundPanel.stop_countdown()

func disconnected(id:int):
	var disconnected_panel = user_disconnect_scene.instantiate()
	add_child(disconnected_panel)
	disconnected_panel.set_user_id(str(id))
