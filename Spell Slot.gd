extends Node
class_name Spell_Slot

@export var spell:Spell
var caster:Player
var spell_index:int
var can_activate:bool = true
var currently_held:bool = false
var time_start_held:int
var is_empty=true
#var held_time:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (currently_held and spell.ping_asap):
		spell.held(caster,spell_index)

func swap_spell(new_spell:Spell):
	if new_spell==null:
		is_empty=true
	else:
		is_empty=false
		$Cooldown_Timer.stop()
		$Held_Timer.stop()
		spell=new_spell
		if (spell.cooldown_time>0):
			$Cooldown_Timer.wait_time=float(spell.cooldown_time)/1000
		if (spell.held_ping_time>0 and !spell.ping_asap):
			$Held_Timer.wait_time=float(spell.held_ping_time)/1000
		if !spell.cooldown_on_activate and !spell.cooldown_on_release:
			printerr("Spell at slot ",spell_index," has no cooldown activation")

func activate():
	if (spell!=null and can_activate):
		can_activate=false
		spell.activate(caster,spell_index)
		if !spell.ping_asap and spell.held_ping_time>0:
			$Held_Timer.start()
		if spell.cooldown_on_activate:
			$Cooldown_Timer.start()
		currently_held=true
		time_start_held=Time.get_ticks_msec()
		spell.held(caster,spell_index)
		

func release():
	if (currently_held):
		spell.release(caster,spell_index)
		currently_held=false
		$Held_Timer.stop()
		if (spell.cooldown_on_release):
			$Cooldown_Timer.start()

func _on_held_timer_timeout():
	spell.held(caster,spell_index)
	
func _on_cooldown_timer_timeout():
	can_activate=true

func get_held_time():
	var time=(Time.get_ticks_msec()-time_start_held)
	return time
