extends PanelContainer
class_name Status_Effect_Instance
@export var image:Texture2D
@export var flash_on_ping:bool
@export var flash_color:Color
@export var status:Status_Type
var original_caster:Player
var affected_player:Player
var time_start:int
var status_index:int
var status_visible:bool
var stack_count:int = 1
# Called when the node enters the scene tree for the first time.

func _process(delta: float) -> void:
	%StatusPercent.value = (float(%EndTime.ticks_left) / float(%EndTime.wait_ticks))*100

func _on_flash_timer_timeout():
	flash(false)

func flash(state:bool):
	if state:
		%ColorRect.color=flash_color
	else:
		%ColorRect.color=Color.TRANSPARENT


func _on_percent_time_timeout():
	print("Percent ",%StatusPercent.value)
	%StatusPercent.value-=10
	print("END TIME HAS ",%EndTime.ticks_left, " Ticks left")
	#if %StatusPercent.value ==0:
		#_on_end_time_timeout()


func _on_ping_time_timeout():
	status.held(original_caster,status_index)
	if flash_on_ping:
		flash(true)
		$FlashTimer.start()

func stack():
	stack_count+=1
	%"Stack Count".text = str(stack_count)
	%"Stack Count".visible=true
	release(false)
	
	activate()
	
func activate():
	status.activate(original_caster,status_index)
	%EndTime.start()
	if (status.ping_time!=0):
		%PingTime.start()
		status.held(original_caster,status_index)
		
func release(despawn:bool=true):
	print("RELEASED EFFECT HOOOBOYY")
	status.release(original_caster,status_index)
	%EndTime.stop()
	if (status.ping_time!=0):
		%PingTime.stop()
	if despawn:
		SyncManager.despawn(self)
	
func get_held_time():
	var time=(Time.get_ticks_msec()-time_start)
	return time

func _on_end_time_timeout():
	#print("Percent ",%StatusPercent.value)
	release()

func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	if data.get('status',false):
		data['status_path'] = data['status'].get_path()
		#%EndTime.wait_ticks=data['status'].total_effect_time
		#if (data['status'].ping_time!=0):
			#%PingTime.wait_ticks=data['status'].ping_time
		data.erase('status')
	data['caster_path'] = data['caster'].get_path()
	data.erase('caster')
	data['effected_player_path'] = data['effected_player'].get_path()
	data.erase('effected_player')
	#data['status']
	
	return data


func _network_spawn(data: Dictionary) -> void:
	original_caster = get_node(data['caster_path'])
	if data.has('status_path'):
		status=load(data['status_path'])
		status_visible=status.status_visible
		if status_visible:
			flash_on_ping=status.flash_on_ping
			flash_color=status.flash_color
			image=status.image
			%TextureRect.texture=image
		else:
			visible=false
	affected_player=get_node(data['effected_player_path'])
	status_index=data['index']
	%EndTime.wait_ticks=status.total_effect_time
	if (status.ping_time!=0):
		%PingTime.wait_ticks=status.ping_time
	
	activate()

func equals(other_status:Status_Effect_Instance) -> bool:
	if other_status.status ==status:
		return true
	return false
	
func _save_state() ->Dictionary:
	return {
		stack_count = stack_count
	}

func _load_state(state:Dictionary) ->void:
	stack_count=state['stack_count']
