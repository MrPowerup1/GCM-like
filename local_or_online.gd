extends CanvasLayer

signal local()
signal online()

@export var local_scene:PackedScene
@export var online_scene:PackedScene

const DummyNetworkAdaptor = preload("res://addons/godot-rollback-netcode/DummyNetworkAdaptor.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SyncManager.clear_peers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_local_button_down() -> void:
	get_tree().change_scene_to_packed(local_scene)
	SyncManager.network_adaptor = DummyNetworkAdaptor.new()
	GameManager.is_host=true
	SoundFX.select()
	#local.emit()


func _on_online_button_down() -> void:
	get_tree().change_scene_to_packed(online_scene)
	SyncManager.reset_network_adaptor()
	SoundFX.select()
	#online.emit()
