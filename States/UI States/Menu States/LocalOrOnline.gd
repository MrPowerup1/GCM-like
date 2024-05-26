extends State
class_name LocalOrOnline

const DummyNetworkAdaptor = preload("res://addons/godot-rollback-netcode/DummyNetworkAdaptor.gd")

func enter():
	%SelectionUI.visible=true
	%LocalOrOnline.visible=true
	SyncManager.clear_peers()

func exit():
	%LocalOrOnline.visible=false


func _on_local_button_down():
	Transition.emit(self,"PlayerSelect")
	SyncManager.network_adaptor = DummyNetworkAdaptor.new()
	GameManager.is_host=true
	print("local")


func _on_online_button_down():
	Transition.emit(self,"OnlineMatchmaking")
	SyncManager.reset_network_adaptor()
