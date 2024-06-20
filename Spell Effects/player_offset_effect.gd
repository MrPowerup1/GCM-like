extends Positional_Effect
class_name Player_Offset_Effect

#Only for display
@export_category('Offset')
@export var offset_x:int
@export var offset_y:int
@export_category('Effect')
@export var effect:Positional_Effect
#Actual used vector
const fixed_point_factor:int=65536


func trigger(target,caster:Player,spell_index:int,position:SGFixedVector2=target.fixed_position):
	print("System #: ",caster.multiplayer.get_unique_id())
	print("Angle in radians ",float(caster.get_facing())/fixed_point_factor)
	var offset_position = position.copy().add(SGFixed.vector2(offset_x*fixed_point_factor,offset_y*fixed_point_factor).rotated(caster.get_facing()))
	print("Moved from ",position.to_float()," to ",offset_position.to_float())
	effect.trigger(target,caster,spell_index,offset_position)
