extends RefCounted
class_name Lobby

var HostID : int
var Players : Dictionary = {}

func _init(id):
	HostID = id
	
func AddPlayer(id, name):
	Players[id] = {
		"name": name,
		"id": id,
		"index": Players.size() + 1
	}
	return Players[id]

func RemovePlayer(id):	
	Players.erase(id)
	if HostID==id and Players.size() > 0:
		HostID = Players.keys()[0]
