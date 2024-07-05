extends SGArea2D
class_name Area

@export_category ("Main Effects")
enum effect_time {ON_ENTER,ON_EXIT,ON_TIMEOUT,ON_PING,ON_SPAWN}
enum effect_location {CASTER,ALL_TARGETS,NON_CASTER_TARGETS,THIS_AREA}
@export var timings:Array[effect_time]
@export var locations:Array[effect_location]
@export var effects:Array[Spell_Effect]

var caster:Player
var last_frame_bodies:Array = []
#unused
var spell_index:int
@export var ping_time:int
@export var life_time:int
@export var rotate_to_caster:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _network_process(input: Dictionary) -> void:
	check_overlaps()

func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	data['caster_path'] = data['caster'].get_path()
	#if data.get('effects',false):
		#var effects_paths= []
		#for effect in data['effects']:			
			#effects_paths.append(effect.get_path())
		#data['effects_paths']=effects_paths
		#data.erase('effects')
	#if data.get('img',false):
		#data['img_path'] = data['img'].get_path()
		#data.erase('img')
	return data

func _network_spawn(data: Dictionary) -> void:
	#print("Spawning")
	
	fixed_position_x=data['position'].x
	fixed_position_y=data['position'].y
	caster = get_node(data['caster_path'])
	if rotate_to_caster:
		fixed_rotation = caster.get_facing()
	#if data.has('effects_paths'):
		#effects.clear()
		#for path in data['effects_paths']:
			#effects.append(load(path))
	#if data.has('timings'):
		#timings = data['timings']
	#if data.has('locations'):
		#locations=data['locations']
	#if data.has('img_path'):
		#get_node("Sprite2D").texture = load(data['img_path'])
	#if data.has('life_time'):
		#life_time=data['life_time']
	#if data.has('ping_time'):
		#ping_time=data['ping_time']
	%End_Time.wait_ticks=life_time
	%End_Time.start()
	if (ping_time>0):
		%Ping_Time.wait_ticks=ping_time
		%Ping_Time.start()
	trigger_effects_at_time(effect_time.ON_SPAWN)
	spawn_specifics()		
	sync_to_physics_engine()

	
func spawn_specifics():
	pass

func release():
	trigger_effects_at_time(effect_time.ON_TIMEOUT,last_frame_bodies)	
	SyncManager.despawn(self)

func _on_end_time_timeout():
	release()

func _on_ping_time_timeout():
	trigger_effects_at_time(effect_time.ON_PING,last_frame_bodies)

func check_overlaps():
	var this_frame_bodies = get_overlapping_bodies()
	var bodies_entered = []
	var bodies_exited = []
	for body in this_frame_bodies:
		if not last_frame_bodies.has(body):
			bodies_entered.append(body)
	for body in last_frame_bodies:
		if not this_frame_bodies.has(body):
			bodies_exited.append(body)
	if bodies_entered.size()>0:
		trigger_effects_at_time(effect_time.ON_ENTER,bodies_entered)
		collided(bodies_entered)
	if bodies_exited.size()>0:
		trigger_effects_at_time(effect_time.ON_EXIT,bodies_exited)
	last_frame_bodies = this_frame_bodies	

func collided(bodies):
	pass

func trigger_effect(effect:Spell_Effect,target):
	if (effect==null):
		pass
	elif (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,spell_index,fixed_position)
	else:
		effect.trigger(target,caster,spell_index)

func trigger_effects_at_time(timing:effect_time,targets=null):
	for i in range(timings.size()):
		if timings[i]==timing:
			if locations[i]==effect_location.ALL_TARGETS:
				for target in targets:
					trigger_effect(effects[i],target)
			elif locations[i]==effect_location.NON_CASTER_TARGETS:
				for target in targets:
					if target != caster:
						trigger_effect(effects[i],target)
			elif locations[i]==effect_location.CASTER:
				trigger_effect(effects[i],caster)
			elif locations[i]==effect_location.THIS_AREA:
				trigger_effect(effects[i],self)

func _save_state() ->Dictionary:
	var last_frame_bodies_paths = []
	for body in last_frame_bodies:
		last_frame_bodies_paths.append(body.get_path())
	return {
		position_x=fixed_position_x,
		position_y=fixed_position_y,
		last_frame_bodies_paths=last_frame_bodies_paths
	}

func _load_state(state:Dictionary) ->void:
	fixed_position_x = state['position_x']
	fixed_position_y = state['position_y']
	last_frame_bodies.clear()
	for path in state['last_frame_bodies_paths']:
		last_frame_bodies.append(get_node(path))
	sync_to_physics_engine()

func _interpolate_state(old_state:Dictionary, new_state:Dictionary, weight:float) -> void:
	fixed_position_x = lerp(old_state['position_x'],new_state['position_x'],weight)
	fixed_position_y = lerp(old_state['position_y'],new_state['position_y'],weight)
