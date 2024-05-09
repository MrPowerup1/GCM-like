extends "res://addons/godot-rollback-netcode/RPCNetworkAdaptor.gd"

func is_network_host():
	return GameManager.is_host
