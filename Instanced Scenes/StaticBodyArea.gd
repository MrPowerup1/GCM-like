extends SGStaticBody2D
class_name StaticBodyArea

@export_category ("Main Effects")
#Note: On enter and exit don't work (cant enter body)
enum effect_time {ON_ENTER,ON_EXIT,ON_TIMEOUT,ON_PING,ON_SPAWN}
#Note: Cant really target anything other than caster and this area
enum effect_location {CASTER,ALL_TARGETS,NON_CASTER_TARGETS,THIS_AREA}
@export var timings:Array[effect_time]
@export var locations:Array[effect_location]
@export var effects:Array[Spell_Effect]

var caster:Player
#unused
var spell_index:int
@export var ping_time:int
@export var life_time:int
@export var rotate_to_caster:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	data['caster_path'] = data['caster'].get_path()
	return data

func _network_spawn(data: Dictionary) -> void:
	
	fixed_position_x=data['position'].x
	fixed_position_y=data['position'].y
	caster = get_node(data['caster_path'])
	if rotate_to_caster:
		fixed_rotation = caster.get_facing()
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
	trigger_effects_at_time(effect_time.ON_TIMEOUT)	
	SyncManager.despawn(self)

func _on_end_time_timeout():
	release()

func _on_ping_time_timeout():
	trigger_effects_at_time(effect_time.ON_PING)

func collided(bodies):
	pass

func trigger_effect(effect:Spell_Effect,target):
	if (effect==null):
		pass
	elif (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,spell_index,fixed_position)
	else:
		effect.trigger(target,caster,spell_index)

func trigger_effects_at_time(timing:effect_time):
	for i in range(timings.size()):
		if timings[i]==timing:
			if locations[i]==effect_location.ALL_TARGETS:
				printerr("No ALL_TARGETS for Static Body")
			elif locations[i]==effect_location.NON_CASTER_TARGETS:
				printerr("No NON_CASTER_TARGETS for Static Body")
			elif locations[i]==effect_location.CASTER:
				trigger_effect(effects[i],caster)
			elif locations[i]==effect_location.THIS_AREA:
				trigger_effect(effects[i],self)

func _save_state() ->Dictionary:
	return {
		position_x=fixed_position_x,
		position_y=fixed_position_y
	}

func _load_state(state:Dictionary) ->void:
	fixed_position_x = state['position_x']
	fixed_position_y = state['position_y']
	sync_to_physics_engine()

func _interpolate_state(old_state:Dictionary, new_state:Dictionary, weight:float) -> void:
	fixed_position_x = lerp(old_state['position_x'],new_state['position_x'],weight)
	fixed_position_y = lerp(old_state['position_y'],new_state['position_y'],weight)
