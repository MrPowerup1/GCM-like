extends PanelContainer
class_name SkinSelectPanel

signal exit()
signal next()

func left():
	%LeftButton._pressed()
	print("Go Left")
func right():
	%RightButton._pressed()
	print ("Go RIght")
func up():
	%LeftButton._pressed()
	print("Go Up")
func down():
	%RightButton._pressed()
	print ("Go Down")
func select():
	print ("Selecting")
	next.emit()
func back():
	exit.emit()
