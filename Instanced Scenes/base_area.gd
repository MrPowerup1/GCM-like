extends SGArea2D
class_name Area

var enter_effect:Spell_Effect
var exit_effect:Spell_Effect
var exit_trigger_on_timeout:bool
var ping_effect:Spell_Effect
var caster:Player
#unused
var spell_index:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

#func initialize(cast:Player,img:Texture2D,life_time:int,ping_time:int,enter:Spell_Effect,exit:Spell_Effect,ping:Spell_Effect,trigger_exit_on_timeout:bool):
	#get_node("Sprite2D").texture=img
	#%End_Time.wait_time=float(life_time)/1000
	#if (ping_time!=0):
		#%Ping_Time.wait_time=float(ping_time)/1000
	#enter_effect=enter
	#exit_effect=exit
	#ping_effect=ping
	#exit_trigger_on_timeout=trigger_exit_on_timeout
	#%End_Time.start()
	#if (ping_effect!=null):
		#%Ping_Time.start()
	#caster=cast
	##%MultiplayerSynchronizer.set_multiplayer_authority(caster.get_parent().device_id)

func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	data['caster_path'] = data['caster'].get_path()
	data.erase('caster')
	if data.get('enter',false):
		data['enter_path'] = data['enter'].get_path()
		data.erase('enter')
	if data.get('exit',false):
		data['exit_path'] = data['exit'].get_path()
		data.erase('exit')
	if data.get('ping',false):
		data['ping_path'] = data['ping'].get_path()
		data.erase('ping')
	if data.get('img',false):
		data['img_path'] = data['img'].get_path()
		data.erase('img')
	return data

func _network_spawn(data: Dictionary) -> void:
	fixed_position_x=data['position'].x
	fixed_position_y=data['position'].y
	caster = get_node(data['caster_path'])
	if data.has('enter_path'):
		enter_effect=load(data['enter_path'])
	if data.has('exit_path'):
		exit_effect=load(data['exit_path'])
	if data.has('ping_path'):
		ping_effect=load(data['ping_path'])
	if data.has('img_path'):
		get_node("Sprite2D").texture = load(data['img_path'])
	%End_Time.wait_ticks=data['life_time']
	if (data['ping_time'] !=0):
		%Ping_Time.wait_ticks=data['ping_time']
	exit_trigger_on_timeout = data['trigger_exit_on_timeout']
	%End_Time.start()
	if ping_effect!=null:
		%Ping_Time.start()
	

#@rpc("any_peer","call_local")
func release():
	#HACK: Should be its own effect only in the target moving version
	caster.my_input.reset_velocity_reference()	
	
	if (exit_trigger_on_timeout):
		for body in get_overlapping_bodies():
			trigger_spell(exit_effect,body)	
	SyncManager.despawn(self)

func _on_end_time_timeout():
	release()

func _on_ping_time_timeout():
	for body in get_overlapping_bodies():
		trigger_spell(ping_effect,body)	

func _on_body_entered(body):
	trigger_spell(enter_effect,body)

func _on_body_exited(body):
	trigger_spell(exit_effect,body)

func trigger_spell(effect:Spell_Effect,target):
	if (effect==null):
		pass
	elif (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,-1,fixed_position)
	else:
		effect.trigger(target,caster,-1)
