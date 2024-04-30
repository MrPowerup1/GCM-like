extends Area2D
class_name Area

var enter_effect:Spell_Effect
var exit_effect:Spell_Effect
var exit_trigger_on_timeout:bool
var ping_effect:Spell_Effect
var caster:Player
#unused
var spell_index:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func initialize(cast:Player,img:Texture2D,life_time:int,ping_time:int,enter:Spell_Effect,exit:Spell_Effect,ping:Spell_Effect,trigger_exit_on_timeout:bool):
	get_node("Sprite2D").texture=img
	%End_Time.wait_time=float(life_time)/1000
	if (ping_time!=0):
		%Ping_Time.wait_time=float(ping_time)/1000
	enter_effect=enter
	exit_effect=exit
	ping_effect=ping
	exit_trigger_on_timeout=trigger_exit_on_timeout
	%End_Time.start()
	if (ping_effect!=null):
		%Ping_Time.start()
	caster=cast
	%MultiplayerSynchronizer.set_multiplayer_authority(caster.get_parent().device_id)

@rpc("any_peer","call_local")
func release():
	if (exit_trigger_on_timeout):
		for body in get_overlapping_bodies():
			trigger_spell(exit_effect,body)	
	queue_free()

func _on_end_time_timeout():
	release.rpc()

func _on_ping_time_timeout():
	for body in get_overlapping_bodies():
		trigger_spell(ping_effect,body)	

func _on_body_entered(body):
	trigger_spell(enter_effect,body)

func _on_body_exited(body):
	trigger_spell(exit_effect,body)

func trigger_spell(effect:Spell_Effect,target):
	if (effect==null):
		pass
	elif (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,-1,position)
	else:
		effect.trigger(target,caster,-1)
