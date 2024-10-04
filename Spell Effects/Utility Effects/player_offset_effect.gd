extends Positional_Effect
class_name Player_Offset_Effect

#Only for display
@export_category('Offset')
@export var offset_x:int
#Currently no use
@export var offset_y:int
@export_category('Effect')
@export var effect:Positional_Effect
#Actual used vector
const fixed_point_factor:int=65536


func trigger(target,caster:Player,spell_index:int,position:SGFixedVector2=target.fixed_position):
	
	
	#var offset_position = position.copy().add(SGFixed.vector2(offset_x*fixed_point_factor,offset_y*fixed_point_factor).rotated(caster.get_facing()))
	var offset_position = position.copy().add(MathHelper.get_unit_at_angle(caster.get_facing()).mul(offset_x*fixed_point_factor))
	effect.trigger(target,caster,spell_index,offset_position)
