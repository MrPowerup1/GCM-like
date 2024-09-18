extends CanvasLayer

signal join
signal back
signal server

func get_ip() -> String:
	return %IP.text
# Called when the node enters the scene tree for the first time.


func _on_join_button_down() -> void:
	join.emit()

func _on_back_button_down() -> void:
	back.emit()


func _on_server_button_down() -> void:
	server.emit()
