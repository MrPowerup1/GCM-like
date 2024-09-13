extends Node
class_name Status_Effect_Instance

@export var status:Status_Type
var original_caster:Player
var affected_player:Player
var time_start:int
var status_index:int
#var visual:StatusIcon
#var held_time:float

# Called when the node enters the scene tree for the first time.
#func initialize(new_status:Status_Type,caster:Player,target:Player,index:int):
	#status=new_status
	#original_caster=caster
	#affected_player= target
	#time_start=Time.get_ticks_msec()
	#status_index=index
	#$End_Time.wait_ticks=status.total_effect_time
	#if (status.ping_time!=0):
		#$Ping_Time.wait_time=status.ping_time
	#$End_Time.start()
	#activate()
	
func activate():
	status.activate(original_caster,status_index)
	if (status.ping_time!=0):
		$Ping_Time.start()
		status.held(original_caster,status_index)
		
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
	release()

func _on_ping_time_timeout():
	status.held(original_caster,status_index)

func lower_index():
	status_index-=1


func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	if data.get('status',false):
		data['status_path'] = data['status'].get_path()
		data.erase('status')
	#if data.get('effects',false):
		#data['effects_paths'] = []
		#for effect in data['effects']:
			#data['effects_paths'].append(effect.get_path())
	data['caster_path'] = data['caster'].get_path()
	data.erase('caster')
	data['effected_player_path'] = data['effected_player'].get_path()
	data.erase('effected_player')
	
	return data


func _network_despawn():
	print("despawn")
	#if visual!=null and status.display_visual:
		##$Percent_Time.stop()
		##$End_Time.stop()
		##$Ping_Time.stop()
		#visual.visible=false

func _network_spawn(data: Dictionary) -> void:
	original_caster = get_node(data['caster_path'])
	if data.has('status_path'):
		status=load(data['status_path'])
	#elif data.has('effects_paths'):
		#status = Status_Type.new()
		#for path in data['effects_paths']:
			#status.effects.append(load(path))
		#status.timings=data['timings']
		#status.total_effect_time = data['total_effect_time']
		#status.ping_time=data['ping_time']
	affected_player=get_node(data['effected_player_path'])
	status_index=data['index']
	$End_Time.wait_ticks=status.total_effect_time
	$Percent_Time.wait_ticks=status.total_effect_time/10
	if (status.ping_time!=0):
		$Ping_Time.wait_time=status.ping_time
	$End_Time.start()
	$Percent_Time.start()
	#print("spawn",visual)
	#if visual == null and status.display_visual:
		#visual=status.status_visual.instantiate()
		#print("Visual is now ",visual)
		#affected_player.new_status_visual(visual)
	activate()


