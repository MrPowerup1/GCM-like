extends Positional_Effect
class_name Control_Effect

@export var effect_to_control:Spell_Effect

func trigger(target,caster:Player,spell_index:int,position:Vector2=target.position):
	var returned_target=null
	if effect_to_control is Positional_Effect:
		returned_target=(effect_to_control as Positional_Effect).trigger(target,caster,spell_index,position)
	else:
		returned_target= effect_to_control.trigger(target,caster,spell_index)
	if (returned_target !=null and returned_target is Node2D and (returned_target as Node2D).has_node("PlayerCharacterInput")):
		var to_control=(returned_target as Node2D).get_node("PlayerCharacterInput")
		var caster_control=caster.get_node("PlayerCharacterInput")
		to_control.input_keys = caster_control.input_keys
		to_control.device_id = caster_control.device_id
		to_control.device = caster_control.device
