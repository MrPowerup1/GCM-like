extends SGArea2D
class_name projectile


@export_category ("Main Effects")
enum effect_time {ON_HIT,ON_TIMEOUT,ON_PING}
enum effect_location {CASTER,TARGET,PROJECTILE}
@export var timings:Array[effect_time]
@export var locations:Array[effect_location]
@export var effects:Array[Spell_Effect]

@export_category("Old for compatibility")
@export var hit_effect:Spell_Effect
@export var self_effect_on_hit:Spell_Effect
@export var self_effect_on_timeout:Spell_Effect
#the held function will be called repeatedly while still held, based on timer
@export var ping_time:int
@export var life_time:int

var move_dir:SGFixedVector2

var caster:Player
var piercing:bool
var last_frame_bodies:Array = []
@export var velocity:Velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#func _physics_process(delta):
	
func _network_preprocess(input: Dictionary) -> void:
	sync_to_physics_engine()

func _network_process(input: Dictionary) -> void:
	velocity.update_pos()
	check_overlaps()

func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	data['caster_path'] = data['caster'].get_path()
	data.erase('caster')
	if data.get('effects',false):
		var effects_paths= []
		for effect in data['effects']:			
			effects_paths.append(effect.get_path())
		data['effects_paths']=effects_paths
		data.erase('effects')
	#OLD VERSION (Compatitbility
	if data.get('hit_effect',false):
		data['hit_effect_path'] = data['hit_effect'].get_path()
		data.erase('hit_effect')
	if data.get('self_effect_on_hit',false):
		data['self_effect_on_hit_path'] = data['self_effect_on_hit'].get_path()
		data.erase('self_effect_on_hit')
	if data.get('self_effect_on_timeout',false):
		data['self_effect_on_timeout_path'] = data['self_effect_on_timeout'].get_path()
		data.erase('self_effect_on_timeout')
	
	if data.get('img',false):
		data['img_path'] = data['img'].get_path()
		data.erase('img')
	return data

func _network_spawn(data: Dictionary) -> void:
	#print("Spawning")
	fixed_position_x=data['position'].x
	fixed_position_y=data['position'].y
	caster = get_node(data['caster_path'])
	if data.has('effects_paths'):
		effects.clear()
		for path in data['effects_paths']:
			effects.append(load(path))
	timings = data['timings']
	locations=data['locations']
	
	#Compatibility
	if data.has('hit_effect_path'):
		hit_effect=load(data['hit_effect_path'])
	if data.has('self_effect_on_hit_path'):
		self_effect_on_hit=load(data['self_effect_on_hit_path'])
	if data.has('self_effect_on_timeout_path'):
		self_effect_on_timeout=load(data['self_effect_on_timeout_path'])
	
	if data.has('img_path'):
		get_node("Sprite2D").texture = load(data['img_path'])
	life_time=data['life_time']
	ping_time=data['ping_time']
	%Lifetime.wait_ticks=life_time
	%Lifetime.start()
	if (ping_time > 0):
		%Pingtime.wait_ticks=ping_time
		%Pingtime.start()
	sync_to_physics_engine()
	velocity.set_speed(data['speed'])
	piercing=data['piercing']
	start_moving()
	
	
func start_moving():
	velocity.constant_vel(caster.get_facing())
	


@rpc("any_peer","call_local")
func release():
	trigger_effects_at_time(effect_time.ON_TIMEOUT,caster)
	SyncManager.despawn(self)
	

func body_just_entered(body):
	trigger_effects_at_time(effect_time.ON_HIT,body)
	if (piercing and body.is_in_group("pierceable")):
		pass
	else:	
		release()

func check_overlaps():
	var this_frame_bodies = get_overlapping_bodies()
	for body in this_frame_bodies:
		if not last_frame_bodies.has(body):
			body_just_entered(body)	
	last_frame_bodies = this_frame_bodies

func trigger_effect(effect:Spell_Effect,target):
	if (effect==null):
		pass
	elif (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,-1,fixed_position)
	else:
		effect.trigger(target,caster,-1)

func trigger_effects_at_time(timing:effect_time,target=null):
	#Trigger these for compatibility
	if timing==effect_time.ON_HIT:
		trigger_effect(hit_effect,target)
		trigger_effect(self_effect_on_hit,caster)
	if timing==effect_time.ON_TIMEOUT:
		trigger_effect(self_effect_on_timeout,caster)
	
	for i in range(timings.size()):
		if timings[i]==timing:
			if locations[i]==effect_location.TARGET:
				trigger_effect(effects[i],target)
			elif locations[i]==effect_location.CASTER:
				trigger_effect(effects[i],caster)
			elif locations[i]==effect_location.PROJECTILE:
				trigger_effect(effects[i],self)

func _save_state() ->Dictionary:
	var last_frame_bodies_paths = []
	for body in last_frame_bodies:
		last_frame_bodies_paths.append(body.get_path())
	return {
		position_x=fixed_position_x,
		position_y=fixed_position_y,
		last_frame_bodies_paths=last_frame_bodies_paths,
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


func _on_lifetime_timeout():
	release.rpc()


func _on_pingtime_timeout():
	print("test")
	trigger_effects_at_time(effect_time.ON_PING)
