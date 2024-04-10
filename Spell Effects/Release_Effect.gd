extends Spell_Effect
class_name Release_Effect

@export var release_state:bool = false

func trigger (caster:Player,spell_index:int):
	caster.set_release_permission(spell_index,release_state)
