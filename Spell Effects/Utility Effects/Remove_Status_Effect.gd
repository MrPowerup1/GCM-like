extends Spell_Effect
class_name Remove_Status_Effect

@export var remove_all:bool = false
@export var names_to_remove:Array[String]

func trigger(target,caster:Player,spell_index:int):
	if remove_all:
		target.clear_status(-1)
	else:
		for name in names_to_remove:
			target.clear_status_with_name(name)
	
