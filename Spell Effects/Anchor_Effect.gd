extends Spell_Effect
class_name Anchor_Effect

@export var set_anchor_to:bool

func trigger(caster:Player,spell_index:int):
	caster.anchor(set_anchor_to)
