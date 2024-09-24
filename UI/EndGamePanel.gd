extends CanvasLayer

@export var base_scene_path:String = "res://local_or_online.tscn"
@export var player_select_path:String = "res://player_select_menu.tscn"
@export var user_disconnect_scene:PackedScene

signal restart
signal end

func _ready():
	%Skin.material = %Skin.material.duplicate(true)
	display_winner()
	Client.peer_disconnect.connect(disconnected)

func display_winner():
	var winner_index = GameManager.alive_players.values()[0]
	var winner = GameManager.players[winner_index]
	var winner_skin = (GameManager.universal_skin_deck.cards[winner.selected_skin] as SkinCard).skin
	%Skin.texture=winner_skin.texture
	%Skin.material.set_shader_parameter("new_color",winner_skin.color)
	GameManager.alive_players.clear()


func _on_restart_button_down() -> void:
	get_tree().change_scene_to_file(player_select_path)
	#restart.emit()


func _on_end_button_down() -> void:
	Client.leave_lobby()
	get_tree().change_scene_to_file(base_scene_path)
	#end.emit()

func disconnected(id:int):
	var disconnected_panel = user_disconnect_scene.instantiate()
	add_child(disconnected_panel)
	disconnected_panel.set_user_id(str(id))
