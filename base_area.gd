extends Area2D
class_name Area

var enter_effect:Spell_Effect
var exit_effect:Spell_Effect
var exit_trigger_on_timeout:bool
var ping_effect:Spell_Effect
var caster:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func initialize(cast:Player,img:Texture2D,life_time:int,ping_time:int,enter:Spell_Effect,exit:Spell_Effect,ping:Spell_Effect,trigger_exit_on_timeout:bool):
	get_node("Sprite2D").texture=img
	%End_Time.wait_time=life_time/1000
	%Ping_Time.wait_time=ping_time/1000
	enter_effect=enter
	exit_effect=exit
	ping_effect=ping
	exit_trigger_on_timeout=trigger_exit_on_timeout
	%End_Time.start()
	if (ping_effect!=null):
		%Ping_Time.start()
	caster=cast



func _on_end_time_timeout():
	if (exit_trigger_on_timeout):
		if (exit_effect is Positional_Effect):
			for body in get_overlapping_bodies():
				(exit_effect as Positional_Effect).trigger(body,-1,position)
		else:
			for body in get_overlapping_bodies():
				exit_effect.trigger(body,-1)
	
	queue_free()


func _on_ping_time_timeout():
	if (ping_effect is Positional_Effect):
		for body in get_overlapping_bodies():
			(ping_effect as Positional_Effect).trigger(body,-1,position)
	else:
		for body in get_overlapping_bodies():
			ping_effect.trigger(body,-1)
	


func _on_body_entered(body):
	if (enter_effect is Positional_Effect):
		(enter_effect as Positional_Effect).trigger(body,-1,position)
	else:
		enter_effect.trigger(body,-1)

func _on_body_exited(body):
	if (exit_effect is Positional_Effect):
		(exit_effect as Positional_Effect).trigger(body,-1,position)
	else:
		exit_effect.trigger(body,-1)
