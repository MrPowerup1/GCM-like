extends PanelContainer

var animator:AnimationPlayer

signal start_round()

func start_countdown():
	%AnimationPlayer.play("Countdown")

func stop_countdown():
	%AnimationPlayer.stop()

func countdown_over():
	start_round.emit()
