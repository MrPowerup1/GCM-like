extends Area
class_name ControlledArea


@export var velocity:Velocity



func _network_preprocess(input: Dictionary) -> void:
	sync_to_physics_engine()

func _network_process(input: Dictionary) -> void:
	velocity.update_pos()
	check_overlaps()

func spawn_specifics():
	caster.get_node("PlayerCharacterInput").velocity=velocity
	caster.spell_released.connect(spell_released)

func _network_despawn() ->void:
	caster.input.reset_velocity_reference()	
	caster.get_node("PlayerCharacterInput").reset_velocity_reference()

func spell_released(index:int):
	if index==spell_index:
		release()

func _on_end_time_timeout():
	release()

func _on_ping_time_timeout():	
	trigger_effects_at_time(effect_time.ON_PING,last_frame_bodies)

