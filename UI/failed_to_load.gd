extends CanvasLayer

signal back
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_lobby_id(id:String):
	%"Lobby ID".text=id

func _on_back_button_down() -> void:
	back.emit()
	queue_free()
