extends Panel

signal exit()

func left():
	pass
func right():
	pass
func up():
	pass
func down():
	pass
func select():
	pass
func back():
	exit.emit()
