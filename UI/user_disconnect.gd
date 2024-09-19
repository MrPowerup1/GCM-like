extends CanvasLayer

@export var base_scene_path: String = "res://local_or_online.tscn"

signal back
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_down() -> void:
	Client.leave_lobby()
	get_tree().change_scene_to_file(base_scene_path)
	
func set_user_id(id:String):
	%"User ID".text=id
