extends PanelContainer

var health = 0


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
	
func _on_damage_delay_timeout():
	%DamageBar.value = health
