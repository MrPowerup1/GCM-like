extends SGArea2D
class_name Area

var enter_effect:Spell_Effect
var exit_effect:Spell_Effect
var exit_trigger_on_timeout:bool
var ping_effect:Spell_Effect
var caster:Player
var last_frame_bodies:Array = []
#unused
var spell_index:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _network_process(input: Dictionary) -> void:
	check_overlaps()

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
	print("Spawning")
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
	print(%End_Time.wait_ticks)
	if (data['ping_time'] !=0):
		%Ping_Time.wait_ticks=data['ping_time']
	exit_trigger_on_timeout = data['trigger_exit_on_timeout']
	%End_Time.start()
	if ping_effect!=null:
		%Ping_Time.start()
	sync_to_physics_engine()
	

#@rpc("any_peer","call_local")
func release():
	print("released")
	#HACK: Should be its own effect only in the target moving version
	caster.input.reset_velocity_reference()	
	
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

func check_overlaps():
	var this_frame_bodies = get_overlapping_bodies()
	for body in this_frame_bodies:
		if not last_frame_bodies.has(body):
			trigger_spell(enter_effect,body)
	for body in last_frame_bodies:
		if not this_frame_bodies.has(body):
			trigger_spell(exit_effect,body)
	last_frame_bodies = this_frame_bodies	

func trigger_spell(effect:Spell_Effect,target):
	if (effect==null):
		pass
	elif (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,-1,fixed_position)
	else:
		effect.trigger(target,caster,-1)

func _save_state() ->Dictionary:
	return {
		position_x=fixed_position_x,
		position_y=fixed_position_y,
		last_frame_bodies=last_frame_bodies
	}

func _load_state(state:Dictionary) ->void:
	fixed_position_x = state['position_x']
	fixed_position_y = state['position_y']
	last_frame_bodies=state['last_frame_bodies']
	sync_to_physics_engine()
