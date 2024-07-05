extends Spell_Effect
class_name Speed_Effect

@export var set_speed:bool
@export var set_friction:bool
@export_category("FIXED POINT: 65536 is base speed")
@export var speed_factor:int
@export var friction_factor:int

#@export var reset_speed:bool
#@export var reset_friction:bool
#@export var set_speed:float
#@export var set_friction:float


func trigger (target,caster:Player,spell_index:int):
	if target.has_node(NodePath("Velocity")):
		if set_speed:
			target.get_node(NodePath("Velocity")).set_speed(speed_factor)
		if set_friction:
			target.get_node(NodePath("Velocity")).set_friction(friction_factor)
# Called when the node enters the scene tree for the first time.
