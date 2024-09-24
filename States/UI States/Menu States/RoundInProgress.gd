extends State
class_name RoundInProgress

func enter():
	%SelectionUI.visible=false
	print("Round started")
	
	#HACK: Only call once (if player is server), does this still work if player is not hosting? 
	if GameManager.is_host:
		#await get_tree().create_timer(2).timeout
		print("Sync started")
		SyncManager.start()
		

func exit():
	%SelectionUI.visible=true
	SyncManager.stop()

func physics_process(delta:float):
	if GameManager.alive_players.size() == 1:
		Transition.emit(self,"EndScreen")

func _on_client_peer_disconnect(id):
	%UserDisconnect.set_user_id(str(id))
	Transition.emit(self,"UserDisconnect")
