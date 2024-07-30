extends Positional_Effect
class_name Filter_Effect

enum Restriction_Types{NODE_GROUP,HAS_COMPONENT,DISTANCE_TO_CASTER_LESS_THAN,DISTANCE_TO_CASTER_GREATER_THAN}
@export var restriction_type:Restriction_Types
@export var data:String
@export var effect_to_trigger:Spell_Effect

func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	var do_effect = false
	if (effect_to_trigger==null):
		return
	if restriction_type==Restriction_Types.NODE_GROUP and check_node_group(target):
		do_effect=true
	elif restriction_type==Restriction_Types.HAS_COMPONENT and check_has_component(target):
		do_effect=true
	elif restriction_type==Restriction_Types.DISTANCE_TO_CASTER_LESS_THAN and check_distance(target,caster,false):
		do_effect=true
	elif restriction_type==Restriction_Types.DISTANCE_TO_CASTER_GREATER_THAN and check_distance(target,caster,true):
		do_effect=true
	if do_effect:
		if (effect_to_trigger is Positional_Effect):
			(effect_to_trigger as Positional_Effect).trigger(target,caster,spell_index,location)
		else:
			effect_to_trigger.trigger(target,caster,spell_index)

func check_node_group(target:Node)->bool:
	if target.is_in_group(data):
		return true
	return false
	
func check_has_component(target:Node)->bool:
	if target.has_node(NodePath(data)):
		return true
	return false
	
func check_distance(target:SGFixedNode2D,caster:SGFixedNode2D,greater_than:bool)->bool:
	assert (data.is_valid_int(),"data is not an int")
	if greater_than and target.fixed_position.distance_squared_to(caster.fixed_position) > data.to_int():
		return true
	elif !greater_than and target.fixed_position.distance_squared_to(caster.fixed_position) < data.to_int():
		return true
	return false
