extends Node

#@export var spell_slot_scene:PackedScene
#@export var num_slots:int = 2
@export var known_spells:Array[Spell]=[]
var slots:Array[Spell_Slot]=[]


var caster:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	caster=get_parent()
	for slot in get_children():
		slots.append(slot)
	#if (spell_slot_scene!=null):
		##for i in range(num_slots):
			##var new_slot = SyncManager.spawn('Spell Slot',self,spell_slot_scene,{caster=caster,spell_index=i})
			##slots.append(new_slot)
	#else:
		#printerr("Null Spell Slot Scene")
	
	caster.num_spells=slots.size()
	#Replace this later when there needs to be spell selection
	if known_spells != null and known_spells.size()>0:
		for i in range(slots.size()):
			slots[i].swap_spell(known_spells[i])
			
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer","call_local")
func activate(spell_index:int):
	if spell_index < slots.size():
		slots[spell_index].activate()
	else:
		printerr("Activating unknown spell slot")
	#active_spells[spell_index].activate(caster)

@rpc("any_peer","call_local")
func release(spell_index:int):
	if spell_index < slots.size():
		slots[spell_index].release()
		
	else:
		printerr("Releasing unknown spell slot")
	

func equip_spell(known_index:int,equip_index:int=-1):
	if known_index < known_spells.size():
		if equip_index == -1:
			for i in range(slots.size()):
				if slots[i].is_empty:
					equip_index=i
		if equip_index!= -1 and equip_index < slots.size():
			slots[equip_index].swap_spell(known_spells[known_index])

func unequip_spell(equip_index:int=-1):
	if equip_index == -1:
		for i in range(slots.size()):
			if !slots[slots.size()-1-i].is_empty:
				equip_index=i
	if equip_index!= -1 and equip_index < slots.size():
			slots[equip_index].swap_spell(null)
	
func learn_spell(new_spell:Spell):
	known_spells.append(new_spell)

func get_held_time(spell_index:int):
	return slots[spell_index].get_held_time()
