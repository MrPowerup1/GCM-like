extends Node
class_name Spell_Slot

@export var spell:Spell_Type
var caster:Player
@export var spell_index:int
var can_activate:bool = true
var currently_held:bool = false
var time_start_held:int
#var held_time:float

# Called when the node enters the scene tree for the first time.
func _ready():
	caster=get_parent().get_parent()
	#time_start_held=Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if (currently_held):
		#print ("Held time updated to ",held_time)
		#held_time+=delta

func swap_spell(new_spell:Spell_Type):
	$Cooldown_Timer.stop()
	$Held_Timer.stop()
	spell=new_spell
	$Cooldown_Timer.wait_time=float(spell.cooldown_time)/1000
	$Held_Timer.wait_time=float(spell.held_ping_time)/1000

func activate():
	print ("trying to activate")
	if (can_activate):
		print("activating")
		can_activate=false
		spell.activate(caster,spell_index)
		$Held_Timer.start()
		currently_held=true
		time_start_held=Time.get_ticks_msec()
		#print ("New Time start held ",time_start_held)
		#held_time=0
		#print ("New Time start held ",held_time)
		spell.held(caster,spell_index)
		#print ("doubled New Time start held ",time_start_held)
		

func release():
	print("trying to release")
	if (currently_held):
		print("releasing")
		#print("succesful release")
		spell.release(caster,spell_index)
		currently_held=false
		$Held_Timer.stop()
		$Cooldown_Timer.start()

func _on_held_timer_timeout():
	#print("ping")
	spell.held(caster,spell_index)
	
func _on_cooldown_timer_timeout():
	can_activate=true

func get_held_time():
	#print("Checking time elapsed at ",Time.get_ticks_msec())
	#print ("Held start at ",time_start_held)
	
	var time=(Time.get_ticks_msec()-time_start_held)
	#print("Checking a second time ",Time.get_ticks_msec())
	print("elapsed time ", time)
	return time
