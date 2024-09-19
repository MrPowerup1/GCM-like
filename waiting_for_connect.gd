extends CanvasLayer

signal startRound
signal back
# Called when the node enters the scene tree for the first time.
@export var back_scene_path:String="res://matchmaking_menu.tscn"
@export var next_scene:PackedScene


func _ready() -> void:
	%LobbyID.text = Client.lobbyValue
	Client.peer_joined.connect(update_num_players)
	Client.peer_disconnect.connect(update_num_players)
	Client.host_changed.connect(update_hosting)
	update_hosting(0)

func set_lobby_id(id:String):
	%LobbyID.text=id

#Not used
func set_num_players(num:String):
	%NumPlayers.text=num
	
func update_num_players(data=0):
	print("Update")
	%NumPlayers.text = str(GameManager.peers.size())

func _on_start_round_button_down() -> void:
	#get_tree().change_scene_to_packed(next_scene)
	SoundFX.select()
	start_game.rpc()

@rpc("any_peer","call_local")
func start_game():
	Client.StartGame()
	get_tree().change_scene_to_packed(next_scene)

func _on_back_button_down() -> void:
	SoundFX.back()
	Client.leave_lobby()
	get_tree().change_scene_to_file(back_scene_path)

func update_hosting(id:int):
	%HostPanel.visible=GameManager.is_host
