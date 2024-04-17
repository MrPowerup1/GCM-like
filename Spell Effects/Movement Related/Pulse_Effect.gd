extends Positional_Effect
class_name Pulse_Effect

@export var pulse_to:bool
@export var pulse_from:bool
@export var strength:float


func trigger(target,caster:Player,spell_index:int,location:Vector2=caster.position):
	if (target.has_node(NodePath("Velocity"))):
		if pulse_to:
			target.get_node(NodePath("Velocity")).pulse_to(location,strength)
		elif pulse_from:
			target.get_node(NodePath("Velocity")).pulse_from(location,strength)
