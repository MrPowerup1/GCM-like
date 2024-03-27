extends Spell_Effect
class_name Speed_Effect

@export var reset_speed:bool
@export var reset_friction:bool
@export var set_speed:int
@export var set_friction:int


func trigger (caster:Player,spell_index:int):
	if reset_speed:
		caster.set_speed()
	else:
		caster.set_speed(set_speed)
	if reset_friction:
		caster.set_friction()
	else:
		caster.set_friction(set_friction)
# Called when the node enters the scene tree for the first time.
