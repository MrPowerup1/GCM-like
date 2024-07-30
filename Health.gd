extends Node
class_name Health

@export var max_health:int
@export var current_health:int
@export var temp_health:int
@export var overheal_drain_rate:int
@export var hurt_sound:AudioStreamWAV

signal hurt
signal dead
signal healed
signal health_changed(new_health:int)

func check_death():
	if current_health <= 0:
		dead.emit()

func take_damage(damage:int):
	current_health-=damage
	hurt.emit()
	health_changed.emit(current_health)
	check_death()
	SyncManager.play_sound("hurt",hurt_sound)

func heal(damage:int):
	current_health= min(current_health+damage,max_health)
	healed.emit()
	health_changed.emit(current_health)

#Not implemented fully yet
func overheal(damage:int):
	current_health+=damage
	temp_health = max(current_health-max_health,0)
	health_changed.emit(current_health)
	
func _process(delta):
	if temp_health > 0:
		temp_health = max(temp_health-overheal_drain_rate*delta,0)
		current_health = max(current_health-overheal_drain_rate*delta,max_health)

func reset():
	current_health=max_health
	health_changed.emit(current_health)
