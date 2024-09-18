extends CanvasLayer


signal players_ready
signal players_unready
signal back
signal start_game
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_players_ready() -> void:
	players_ready.emit()


func _on_players_unready() -> void:
	players_unready.emit()



func _on_back_button_down() -> void:
	back.emit()

func _on_start_game_panel_start_round() -> void:
	start_game.emit()

func start_countdown():
	
	%StartGamePanel.start_countdown()
func stop_countdown():
	%StartGamePanel.stop_countdown()
