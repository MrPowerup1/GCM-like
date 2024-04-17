extends Spell_Effect
class_name Anchor_Effect

@export var set_anchor_to:bool

func trigger(target,caster:Player,spell_index:int):
	if (target.has_node(NodePath("Velocity"))):
		target.get_node(NodePath("Velocity")).anchor(set_anchor_to)
