extends Positional_Effect
class_name Area_Effect

@export var area_scene:PackedScene


func trigger (target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	var data_to_send = {
		'position'=location,
		'caster'=caster,
		'spell_index'=spell_index
		}

	var new_area = SyncManager.spawn('Area',caster.get_parent().get_parent(),area_scene,data_to_send)
	return new_area
