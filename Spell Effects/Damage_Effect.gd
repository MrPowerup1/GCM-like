extends Spell_Effect
class_name Damage_Effect

@export var damage_value:int

func trigger(target:Player,spell_index:int):
	target.take_damage(damage_value)
