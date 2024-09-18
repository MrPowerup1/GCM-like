extends CanvasLayer

signal startRound
signal back
# Called when the node enters the scene tree for the first time.

func set_lobby_id(id:String):
	%LobbyID.text=id

func set_num_players(num:String):
	%NumPlayers.text=num

func _on_start_round_button_down() -> void:
	startRound.emit()


func _on_back_button_down() -> void:
	back.emit()
