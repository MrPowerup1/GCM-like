extends CanvasLayer

signal startRound
signal back
# Called when the node enters the scene tree for the first time.
@export var back_scene_path:String="res://matchmaking_menu.tscn"
@export var next_scene:PackedScene


func _ready() -> void:
	%LobbyID.text = Client.lobbyValue
	Client.peer_joined.connect(update_num_players)

func set_lobby_id(id:String):
	%LobbyID.text=id

#Not used
func set_num_players(num:String):
	%NumPlayers.text=num
	
func update_num_players():
	%NumPlayers.text = str(GameManager.peers.size())

func _on_start_round_button_down() -> void:
	#get_tree().change_scene_to_packed(next_scene)
	SoundFX.select()
	startRound.emit()
	

func _on_back_button_down() -> void:
	SoundFX.back()
	back.emit()
