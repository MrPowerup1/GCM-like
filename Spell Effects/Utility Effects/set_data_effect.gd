extends Positional_Effect
class_name Set_Data_Effect

enum Data_Types {INTEGER,STRING,TARGET,CASTER,LOCATION,AREA}
enum Edit_Types {SET,INCREMENT}
@export var data_type:Data_Types
@export var edit_type:Edit_Types
@export var key:String
@export_category("Optional")
@export var data:String
@export var area_effect:Area_Effect

func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	if data_type==Data_Types.INTEGER:
		assert(data.is_valid_int(),"Data type is int, but not valid integer")
		if edit_type == Edit_Types.INCREMENT:
			caster.set_spell_data(spell_index,key,caster.get_spell_data(spell_index,key)+data.to_int())
		if edit_type == Edit_Types.SET:
			caster.set_spell_data(spell_index,key,data.to_int())
	elif data_type==Data_Types.STRING:
		caster.set_spell_data(spell_index,key,data)
	elif data_type==Data_Types.TARGET:
		caster.set_spell_data(spell_index,key,target)
	elif data_type==Data_Types.CASTER:
		caster.set_spell_data(spell_index,key,caster)
	elif data_type==Data_Types.LOCATION:
		caster.set_spell_data(spell_index,key,location)
	elif data_type==Data_Types.AREA:
		caster.set_spell_data(spell_index,key,area_effect.trigger(target,caster,spell_index,location))

#func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	#if data_type==Data_Types.INTEGER:
		#assert(data.is_valid_int(),"Data type is int, but not valid integer")
		#if edit_type == Edit_Types.INCREMENT:
			#caster.set_spell_data(spell_index,key,caster.get_spell_data(spell_index,key)+data.to_int())
		#if edit_type == Edit_Types.SET:
			#caster.set_spell_data(spell_index,key,data.to_int())
	#elif data_type==Data_Types.STRING:
		#caster.set_spell_data(spell_index,key,data)
	#elif data_type==Data_Types.TARGET:
		#caster.set_spell_data(spell_index,key,{"type":"Node","path":target.get_path()})
	#elif data_type==Data_Types.CASTER:
		#caster.set_spell_data(spell_index,key,{"type":"Node","path":caster.get_path()})
	#elif data_type==Data_Types.LOCATION:
		#caster.set_spell_data(spell_index,key,location)
	#elif data_type==Data_Types.AREA:
		#caster.set_spell_data(spell_index,key,{"type":"Node","path":area_effect.trigger(target,caster,spell_index,location).get_path()})
