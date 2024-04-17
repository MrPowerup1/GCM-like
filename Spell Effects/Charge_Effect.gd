extends Spell_Effect
class_name Charge_Effect

@export var threshold:Threshold_Effect

func trigger(target,caster:Player,spell_index:int):
	var time = caster.get_held_time(spell_index)
	threshold.trigger(target,caster,spell_index,time)

# Called when the node enters the scene tree for the first time.

