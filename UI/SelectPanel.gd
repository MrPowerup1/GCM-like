extends PanelContainer
class_name SelectPanel

@export var player_index:int
@export var first:bool
#@export var last:bool


signal exit()
signal next()

func _ready():
	pass

#func refresh():
	#pass
	
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
	pass

func display():
	printerr("Displaying Nothing")
func undisplay():
	printerr("Undisplaying Nothing")

func focused():
	pass

func new_player(new_player_index:int):
	player_index = new_player_index
