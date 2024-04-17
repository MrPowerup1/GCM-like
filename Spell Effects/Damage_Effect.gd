extends Spell_Effect
class_name Damage_Effect

@export var damage_value:int

func trigger(target,caster:Player,spell_index:int):
	if target is Player:
		target.take_damage(damage_value)
