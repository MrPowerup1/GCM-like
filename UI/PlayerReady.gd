extends SelectPanel

signal player_ready
signal player_unready

@rpc("any_peer","call_local")
func left():
	pass
@rpc("any_peer","call_local")
func right():
	pass
@rpc("any_peer","call_local")
func up():
	pass
@rpc("any_peer","call_local")
func down():
	pass
@rpc("any_peer","call_local")
func select():
	pass
@rpc("any_peer","call_local")
func back():
	player_unready.emit()
	exit.emit()
	
func focused():
	%PlayerReady.visible=true
	player_ready.emit()
	
	
