extends Node
class_name Spell_Slot

@export var spell:Spell
@export var caster:Player
@export var spell_index:int
var can_activate:bool = true
var currently_held:bool = false
var is_empty=true
var held_pings:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (currently_held and spell.ping_asap):
		held_pings+=1
		spell.held(caster,spell_index)


func _network_spawn_preprocess(data:Dictionary)->Dictionary:
	data['caster_path']=data['caster'].get_path()
	data.erase('caster')
	return data
	
func _network_spawn(data:Dictionary)->void:
	caster=get_node(data['caster_path'])
	spell_index=data['spell_index']

func swap_spell(new_spell:Spell):
	if new_spell==null:
		is_empty=true
	else:
		held_pings=0
		is_empty=false
		$Cooldown_Timer.stop()
		$Held_Timer.stop()
		spell=new_spell
		if (spell.cooldown_time>0):
			$Cooldown_Timer.wait_ticks=spell.cooldown_time
		if (spell.held_ping_time>0 and !spell.ping_asap):
			$Held_Timer.wait_ticks=spell.held_ping_time
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
		spell.held(caster,spell_index)
		

func release():
	if (currently_held):
		spell.release(caster,spell_index)
		currently_held=false
		$Held_Timer.stop()
		if (spell.cooldown_on_release):
			$Cooldown_Timer.start()
		held_pings=0

func _on_held_timer_timeout():
	held_pings+=1
	spell.held(caster,spell_index)
	
func _on_cooldown_timer_timeout():
	can_activate=true

func get_held_time():
	#TODO: Is there an issue here with rollback?
	return held_pings
	
	
func _save_state() ->Dictionary:
	return {
		can_activate=can_activate,
		currently_held = currently_held,
		held_pings = held_pings,
	}

func _load_state(state:Dictionary) ->void:
	can_activate = state['can_activate']
	currently_held = state['currently_held']
	held_pings = state['held_pings']


	
