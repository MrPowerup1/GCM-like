extends Spell_Effect
class_name Speed_Effect

@export var reset_speed:bool
@export var reset_friction:bool
@export var set_speed:float
@export var set_friction:float


func trigger (target,caster:Player,spell_index:int):
	if target.has_node(NodePath("Velocity")):
		if reset_speed:
			target.get_node(NodePath("Velocity")).set_speed()
		else:
			target.get_node(NodePath("Velocity")).set_speed(set_speed)
		if reset_friction:
			target.get_node(NodePath("Velocity")).set_friction()
		else:
			target.get_node(NodePath("Velocity")).set_friction(set_friction)
# Called when the node enters the scene tree for the first time.
