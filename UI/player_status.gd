extends PanelContainer

var health = 0
var dead = false


func health_changed(new_health:int):
	var prev_health = health
	health= min(%HealthBar.max_value,new_health)
	%HealthBar.value=health
	
	if health < prev_health:
		%DamageDelay.start()
	else:
		%DamageBar.value=health	
	
func init_health(_health):
	health=_health
	%HealthBar.max_value=health
	%HealthBar.value=health
	%DamageBar.value=health
	%DamageBar.max_value=health

func new_status(status:Status_Type,caster:Player):
	if !dead:
		if %StatusManager.has_status(status):
			print("Already have status")
			if status.stacking:
				print("Stacked")
				%StatusManager.stack_status(status)
		else:
			%StatusManager.new_status(status,caster)

func get_held_time(index:int):
	return %StatusManager.get_held_time(index)

func clear_status(index:int = -1):
	%StatusManager.clear_status(index)


func _on_damage_delay_timeout():
	%DamageBar.value = health


func _on_health_dead() -> void:
	dead=true
