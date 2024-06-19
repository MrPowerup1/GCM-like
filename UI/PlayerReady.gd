extends Panel

signal exit()

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
	exit.emit()
