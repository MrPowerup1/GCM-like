extends PanelContainer

var animator:AnimationPlayer

func _ready():
	%AnimationPlayer.play("Animate Join Sprite")

signal next()

func left():
	pass
func right():
	pass
func up():
	pass
func down():
	pass
func select():
	next.emit()
func back():
	pass
