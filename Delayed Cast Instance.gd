extends Node
class_name DelayedCastInstance

@export var effect:Spell_Effect
var caster:Player
var target:Player
var delay_time:int
var spell_index:int
var position:SGFixedVector2
#var held_time:float
# Called when the node enters the scene tree for the first time.
	




func _network_spawn_preprocess(data: Dictionary) -> Dictionary:
	data['effect_path'] = data['effect'].get_path()
	data.erase('effect')
	data['caster_path'] = data['caster'].get_path()
	data.erase('caster')
	data['target_path'] = data['target'].get_path()
	data.erase('target')
	return data

func _network_spawn(data: Dictionary) -> void:
	caster = get_node(data['caster_path'])
	effect=load(data['effect_path'])
	target=get_node(data['target_path'])
	spell_index=data['spell_index']
	%Delay.wait_ticks=data['delay_time']
	%Delay.start()
	if data.has('position_x'):
		position = SGFixed.vector2(data['position_x'],data['position_y'])



func _on_delay_timeout():
	if effect is Positional_Effect and position!=null:
		(effect as Positional_Effect).trigger(target,caster,spell_index,position)
	else:
		effect.trigger(target,caster,spell_index)
	SyncManager.despawn(self)
