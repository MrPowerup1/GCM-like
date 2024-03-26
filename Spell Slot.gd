extends Node
class_name Spell_Slot

@export var spell:Spell_Type
var caster:Player
var spell_index:int
var can_activate:bool = true
var currently_held:bool = false
var held_time:float =0
# Called when the node enters the scene tree for the first time.
func _ready():
	caster=get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (currently_held):
		held_time+=delta

func swap_spell(new_spell:Spell_Type):
	%Cooldown_Timer.stop()
	%Held_Timer.stop()
	spell=new_spell
	%Cooldown_Timer.wait_time=spell.cooldown_time
	%Held_Timer.wait_time=spell.held_ping_time

func activate():
	if (can_activate):
		can_activate=false
		spell.activate(caster,spell_index)
		spell.held(caster,spell_index)
		%Held_Timer.start()
		currently_held=true

func release():
	if (currently_held):
		spell.release(caster,spell_index)
		currently_held=false
		held_time=0
		%Held_Timer.stop()
		%Cooldown_Timer.start()

func _on_held_timer_timeout():
	spell.held(caster,spell_index)
	
func _on_cooldown_timer_timeout():
	can_activate=true

func get_held_time():
	print (held_time)
	return held_time
