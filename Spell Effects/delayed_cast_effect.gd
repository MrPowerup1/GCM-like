extends Spell_Effect
class_name Delayed_Cast_Effect

@export var delay_time:int
@export var effect:Spell_Effect

func trigger(target,caster:Player, spell_index:int):
	print("Delayed effect waiting for ",float(delay_time)/1000.0)
	await caster.get_tree().create_timer(float(delay_time)/1000.0).timeout
	effect.trigger(target,caster,spell_index)
	print("Delayed effect triggered")
