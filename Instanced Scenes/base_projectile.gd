extends SGArea2D
class_name projectile

var move_dir:SGFixedVector2
var hit_effect:Spell_Effect
var self_effect_on_hit:Spell_Effect
var self_effect_on_timeout:Spell_Effect
var caster:Player
var piercing:bool
var last_frame_bodies:Array = []
@export var velocity:Velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#func _physics_process(delta):
	

func _network_process(input: Dictionary) -> void:
	check_overlaps()
	velocity.update_pos()

func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	data['caster_path'] = data['caster'].get_path()
	data.erase('caster')
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
	if data.has('hit_effect_path'):
		hit_effect=load(data['hit_effect_path'])
	if data.has('self_effect_on_hit_path'):
		self_effect_on_hit=load(data['self_effect_on_hit_path'])
	if data.has('self_effect_on_timeout_path'):
		self_effect_on_timeout=load(data['self_effect_on_timeout_path'])
	if data.has('img_path'):
		get_node("Sprite2D").texture = load(data['img_path'])
	%Timer.wait_ticks=data['life_time']
	%Timer.start()
	sync_to_physics_engine()
	velocity.set_speed(data['speed'])
	piercing=data['piercing']
	start_moving()
	
	
func start_moving():
	velocity.constant_vel(caster.get_facing())
	

func _on_timer_timeout():
	release.rpc()

@rpc("any_peer","call_local")
func release():
	trigger_spell(self_effect_on_timeout,caster)
	queue_free()
	

func body_just_entered(body):
	trigger_spell(hit_effect,body)
	trigger_spell(self_effect_on_hit,caster)
	if (!piercing):
		queue_free()

func check_overlaps():
	var this_frame_bodies = get_overlapping_bodies()
	for body in this_frame_bodies:
		if not last_frame_bodies.has(body):
			body_just_entered(body)	
	#for body in last_frame_bodies:
		#if not this_frame_bodies.has(body):
			#trigger_spell(exit_effect,body)
	last_frame_bodies = this_frame_bodies

func trigger_spell(effect:Spell_Effect,target):
	if (effect==null):
		pass
	elif (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,-1,fixed_position)
	else:
		effect.trigger(target,caster,-1)

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
