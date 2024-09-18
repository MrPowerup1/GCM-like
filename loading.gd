extends CanvasLayer
class_name LoadingDisplay

signal load_exceeded_time
signal loaded_successfully(data)
signal loaded_unsuccessfully(data)

#var success_signal:StringName
#var fail_signal:StringName

const my_scene:PackedScene = preload("res://loading.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("New Load")
	$MaxLoadTime.start()
	#connect("Client.failed_to_load_lobby",_unsuccess)
	#connect(success_signal,_success)
	#connect(fail_signal,_success)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#static func new_load(fail_signal:StringName,success_signal:StringName) -> LoadingDisplay:
	#var load = my_scene.instantiate()
	#load.fail_signal=fail_signal
	#load.success_signal=success_signal
	#return load
	

#CONNECT THIS FUNCTION to whatever signal you are waiting on
func success(data:String):
	print("success")
	loaded_successfully.emit(data)
	queue_free()

func unsuccess(data:String):
	print("unsuccess")
	loaded_unsuccessfully.emit(data)
	queue_free()
	
func _on_max_load_time_timeout() -> void:
	print("Time out")
	unsuccess("TIME OUT")
	#queue_free()
