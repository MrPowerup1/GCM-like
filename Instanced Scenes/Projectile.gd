extends Area
class_name projectile



@export var piercing:bool
@export var velocity:Velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#func _physics_process(delta):
	
func _network_preprocess(input: Dictionary) -> void:
	sync_to_physics_engine()

func _network_process(input: Dictionary) -> void:
	velocity.update_pos()
	check_overlaps()


func spawn_specifics():
	start_moving()
	
func start_moving():
	velocity.constant_vel(caster.get_facing())
	
func collided(bodies):
	for body in bodies:
		if body.is_in_group("pierceable"):
			if !piercing:
				release()
		else:
			release()
	
func _on_end_time_timeout():
	release()

func _on_ping_time_timeout():
	trigger_effects_at_time(effect_time.ON_PING,last_frame_bodies)
