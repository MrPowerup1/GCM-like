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
		if has_status(status.status_name):
			print("Already have status")
			if status.stacking and get_status_stack_count(status.status_name) <= status.max_stack_size:
				print("Stacked")
				%StatusManager.stack_status(status.status_name)
		elif has_any_status(status.stack_incompatabilities):
			print("Has Incompatible status")
		else:
			%StatusManager.new_status(status,caster)



func get_held_time(index:int):
	return %StatusManager.get_held_time(index)

func clear_status(index:int = -1):
	%StatusManager.clear_status(index)

func clear_status_with_name(status_name:String):
	%StatusManager.clear_status_with_name(status_name)

func has_status(status_name:String) -> bool:
	return %StatusManager.has_status(status_name)

func has_any_status(status_names:Array[String])->bool:
	for status_name in status_names:
		if %StatusManager.has_status(status_name):
			return true
	return false

func get_status_stack_count(status_name:String)->int:
	return %StatusManager.get_stack_count(status_name)


func _on_damage_delay_timeout():
	%DamageBar.value = health


func _on_health_dead() -> void:
	dead=true
