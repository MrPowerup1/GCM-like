extends CanvasLayer

signal back
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_down() -> void:
	back.emit()

func set_user_id(id:String):
	%"User ID".text=id
