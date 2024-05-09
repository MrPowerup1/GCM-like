extends State
class_name RoundInProgress

func enter():
	%SelectionUI.visible=false
	#HACK: Only call once (if player is server) 
	if multiplayer.get_unique_id() == 1:
		SyncManager.start()

func exit():
	%SelectionUI.visible=true

func process(delta:float):
	if GameManager.alive_players.size() == 1:
		Transition.emit(self,"EndScreen")


