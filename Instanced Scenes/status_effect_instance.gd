extends Node
class_name Status_Effect_Instance

@export var status:Status_Type
var original_caster:Player
var affected_player:Player
var time_start:int
var status_index:int
#var held_time:float

# Called when the node enters the scene tree for the first time.
func initialize(new_status:Status_Type,caster:Player,target:Player,index:int):
	status=new_status
	original_caster=caster
	affected_player= target
	time_start=Time.get_ticks_msec()
	status_index=index
	$End_Time.wait_time=float(status.total_effect_time)/1000
	if (status.ping_time!=0):
		$Ping_Time.wait_time=float(status.ping_time)/1000
	$End_Time.start()
	activate()
	
func activate():
	status.activate(original_caster,status_index)
	if (status.ping_time!=0):
		$Ping_Time.start()
		status.held(original_caster,status_index)
		
@rpc("any_peer","call_local")
func release():
	status.release(original_caster,status_index)
	$End_Time.stop()
	if (status.ping_time!=0):
		$Ping_Time.stop()
	affected_player.clear_status(status_index)


func get_held_time():
	var time=(Time.get_ticks_msec()-time_start)
	return time


func _on_end_time_timeout():
	release.rpc()


func _on_ping_time_timeout():
	status.held(original_caster,status_index)

func lower_index():
	status_index-=1
