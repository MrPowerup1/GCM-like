extends Positional_Effect
class_name Area_Effect

@export var area_scene:PackedScene
enum spawn_types {LEVEL,CASTER,TARGET}
@export var spawn_type:spawn_types = spawn_types.LEVEL

func trigger (target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	var data_to_send = {
		'position'=location,
		'caster'=caster,
		'spell_index'=spell_index
		}
	
	var new_area
	match spawn_type:
		spawn_types.LEVEL:
			new_area = SyncManager.spawn('Area',caster.get_parent().get_parent(),area_scene,data_to_send)
		spawn_types.CASTER:
			data_to_send['position'] = SGFixed.vector2(0,0)
			new_area = SyncManager.spawn('Area',caster,area_scene,data_to_send)
		spawn_types.TARGET:
			data_to_send['position'] = SGFixed.vector2(0,0)
			new_area = SyncManager.spawn('Area',target,area_scene,data_to_send)
	return new_area
