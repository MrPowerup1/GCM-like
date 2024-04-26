extends PanelContainer

var animator:AnimationPlayer

func _ready():
	%AnimationPlayer.play("Animate Join Sprite")

signal next()
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
	next.emit()
@rpc("any_peer","call_local")
func back():
	pass
