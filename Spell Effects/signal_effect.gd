extends Spell_Effect
class_name Signal_Effect

@export var group_name:String
@export var caster_must_match:bool = true
@export var signal_value:String

func trigger (target,caster:Player,spell_index:int):
	for node in get_tree().get_nodes_in_group(group_name):
		if not caster_must_match or node.caster == caster:
			
