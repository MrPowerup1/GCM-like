extends PanelContainer

var animator:AnimationPlayer

signal start_round()

func start_countdown():
	visible=true
	%AnimationPlayer.play("Countdown")

func stop_countdown():
	visible=false
	%AnimationPlayer.stop()

func countdown_over():
	start_round.emit()
