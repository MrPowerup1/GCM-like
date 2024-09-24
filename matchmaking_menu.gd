extends CanvasLayer

signal join
signal back
signal server

@export var back_scene_path:String="res://local_or_online.tscn"
@export var next_scene:PackedScene
@export var loading_scene:PackedScene
@export var failed_loading_lobby_scene:PackedScene

func _ready() -> void:
	pass

func get_ip() -> String:
	return %IP.text
# Called when the node enters the scene tree for the first time.
func get_client_name()->String:
	return %Name.text

func _on_join_button_down() -> void:
	SoundFX.select()
	#join.emit()
	Client.clientName=%Name.text
	Client.join_lobby(%IP.text)
	var load = loading_scene.instantiate()
	add_child(load)
	Client.failed_to_load_lobby.connect(load.unsuccess)
	Client.new_lobby_id.connect(load.success)
	(load as LoadingDisplay).loaded_successfully.connect(go_next_scene)
	(load as LoadingDisplay).loaded_unsuccessfully.connect(fail_to_load)
	#load.connect()
	#get_tree().change_scene_to_packed(next_scene)

func _on_back_button_down() -> void:
	SoundFX.back()
	back.emit()
	#print(back_scene)
	#print(back_scene.resource_name)
	get_tree().change_scene_to_file("res://local_or_online.tscn")
	
	
func _on_server_button_down() -> void:
	SoundFX.select()
	Client.clientName=%Name.text
	Server.start_then_join(%IP.text)
	var load = loading_scene.instantiate()
	add_child(load)
	Client.failed_to_load_lobby.connect(load.unsuccess)
	Client.new_lobby_id.connect(load.success)
	(load as LoadingDisplay).loaded_successfully.connect(go_next_scene)
	(load as LoadingDisplay).loaded_unsuccessfully.connect(fail_to_load)
	#get_tree().change_scene_to_packed(next_scene)
	
func go_next_scene(data):
	get_tree().change_scene_to_packed(next_scene)

func fail_to_load(data:String):
	var error_screen = failed_loading_lobby_scene.instantiate()
	add_child(error_screen)
	error_screen.set_lobby_id(data)
