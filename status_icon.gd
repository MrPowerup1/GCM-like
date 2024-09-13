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
# Called when the node enters the scene tree for the first time.


func _on_flash_timer_timeout():
	flash(false)

func flash(state:bool):
	if state:
		%ColorRect.color=flash_color
	else:
		%ColorRect.color=Color.TRANSPARENT


func _on_percent_time_timeout():
	%StatusPercent.value-=10
	if %StatusPercent.value ==0:
		queue_free()


func _on_ping_time_timeout():
	status.held(original_caster,status_index)
	if flash_on_ping:
		flash(true)
		$FlashTimer.start()


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

func lower_index():
	status_index-=1


func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	if data.get('status',false):
		data['status_path'] = data['status'].get_path()
		data.erase('status')
	data['caster_path'] = data['caster'].get_path()
	data.erase('caster')
	data['effected_player_path'] = data['effected_player'].get_path()
	data.erase('effected_player')
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
	%PercentTime.wait_ticks=status.total_effect_time/10
	if (status.ping_time!=0):
		%PingTime.wait_ticks=status.ping_time
	%EndTime.start()
	%PercentTime.start()
	activate()



