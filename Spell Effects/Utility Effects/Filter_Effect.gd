extends Positional_Effect
class_name Filter_Effect

enum Restriction_Types{NODE_GROUP,HAS_COMPONENT,DISTANCE_TO_CASTER,SPELL_DATA,HAS_STATUS,STATUS_STACK}
enum Comparison_Types{EQUAL,GREATER_THAN,LESS_THAN}
@export var restriction_type:Restriction_Types
@export var data:String

@export_category("Optional")
@export var data_to_compare_to:String
@export var effect_to_trigger:Spell_Effect
@export var comparison_type:Comparison_Types

func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	var do_effect = false
	if (effect_to_trigger==null):
		return
	if restriction_type==Restriction_Types.NODE_GROUP and check_node_group(target):
		do_effect=true
	elif restriction_type==Restriction_Types.HAS_COMPONENT and check_has_component(target):
		do_effect=true
	elif restriction_type==Restriction_Types.DISTANCE_TO_CASTER and check_distance(target,caster):
		do_effect=true
	elif restriction_type==Restriction_Types.SPELL_DATA and check_data(caster,spell_index):
		do_effect=true
	elif restriction_type==Restriction_Types.HAS_STATUS and check_status(target):
		do_effect=true
	elif restriction_type==Restriction_Types.STATUS_STACK and check_status_stack(target):
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
	
func check_distance(target:SGFixedNode2D,caster:SGFixedNode2D)->bool:
	assert (data.is_valid_int(),"data is not an int")
	if comparison_type == Comparison_Types.GREATER_THAN and target.fixed_position.distance_squared_to(caster.fixed_position) > data.to_int():
		return true
	elif comparison_type==Comparison_Types.LESS_THAN and target.fixed_position.distance_squared_to(caster.fixed_position) < data.to_int():
		return true
	elif comparison_type==Comparison_Types.EQUAL and target.fixed_position.distance_squared_to(caster.fixed_position) == data.to_int():
		#Should never happen
		return true
	return false
	
func check_data(caster:Player,spell_index:int)->bool:
	var spell_data = caster.get_spell_data(spell_index,data)
	if comparison_type==Comparison_Types.EQUAL:
		if str(spell_data)==data_to_compare_to:
			return true
	else:
		assert (data_to_compare_to.is_valid_int() and str(spell_data).is_valid_int(),"Trying to compare greater than or less than with non integer")
		if comparison_type == Comparison_Types.GREATER_THAN:
			if str(spell_data).to_int() >data_to_compare_to.to_int():
				return true
		elif comparison_type==Comparison_Types.LESS_THAN:
			if str(spell_data).to_int() < data_to_compare_to.to_int():
				return true
	return false

func check_status(target):
	if target.has_status(data):
		return true
	return false

func check_status_stack(target):
	assert (data_to_compare_to.is_valid_int(),"data to compare to is not an int")
	if comparison_type == Comparison_Types.GREATER_THAN:
		if target.get_status_stack_count(data) > data_to_compare_to.to_int():
			return true
	elif comparison_type==Comparison_Types.LESS_THAN:
		if target.get_status_stack_count(data) < data_to_compare_to.to_int():
			return true
	elif comparison_type==Comparison_Types.EQUAL:
		if target.get_status_stack_count(data) == data_to_compare_to.to_int():
			return true
	return false
