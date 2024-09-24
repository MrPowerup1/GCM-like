extends Positional_Effect
class_name Pulse_Effect

@export var pulse_to:bool
@export var pulse_from:bool
@export var strength:float


func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	if target!=null and (target.has_node(NodePath("Velocity"))):
		if pulse_to:
			target.get_node(NodePath("Velocity")).pulse_to(location,strength)
		elif pulse_from:
			target.get_node(NodePath("Velocity")).pulse_from(location,strength)
