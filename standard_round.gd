extends State
class_name StandardRound

signal EndRound()

func enter():
	pass

func exit():
	pass
func physics_process(delta:float):
	if GameManager.alive_players.size() == 1:
		EndRound.emit()
		
#func _on_client_peer_disconnect(id):
	#
	#%UserDisconnect.set_user_id(str(id))
	#Transition.emit(self,"UserDisconnect")
