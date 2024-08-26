extends Spell_Effect
class_name Damage_Effect

@export var damage_value:int

func trigger(target,caster:Player,spell_index:int):
	if target!= null and (target.has_node(NodePath("Health"))):
		target.get_node(NodePath("Health")).take_damage(damage_value)
