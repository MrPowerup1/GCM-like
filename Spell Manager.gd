extends Node

@export var known_spells:Array[Spell_Type]=[]
var slots:Array[Spell_Slot]=[]


var caster:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	caster=get_parent()
	for child in get_children():
		slots.append(child)
	#Replace this later when there needs to be spell selection
	if known_spells != null and known_spells.size()>0:
		for slot in slots:
			slot.swap_spell(known_spells[0])
			
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate(spell_index:int):
	if spell_index < slots.size():
		slots[spell_index].activate()
	else:
		print("Activating unknown spell slot")
	#active_spells[spell_index].activate(caster)


func release(spell_index:int):
	if spell_index < slots.size():
		slots[spell_index].release()
	else:
		print("Releasing unknown spell slot")
	

func equip_spell(known_index:int,equip_index:int=0):
	if known_index < known_spells.size():
		if equip_index < slots.size():
			slots[equip_index].swap_spell(known_spells[known_index])
	
func learn_spell(new_spell:Spell_Type):
	known_spells.append(new_spell)

func get_held_time(spell_index:int):
	return slots[spell_index].get_held_time()
