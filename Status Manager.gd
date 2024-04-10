extends Node

@export var status_instance_scene:PackedScene
var effected_player:Player

func _ready():
	effected_player=get_parent()

#func activate(spell_index:int):
#	if spell_index < slots.size():
#		slots[spell_index].activate()
#	else:
#		#print("Activating unknown spell slot")
#	#active_spells[spell_index].activate(caster)


#func release(spell_index:int):
#	if spell_index < slots.size():
#		slots[spell_index].release()
#
#	else:
#		#print("Releasing unknown spell slot")
	

func new_status(status:Status_Type,caster:Player):
	var status_instance=status_instance_scene.instantiate()
	add_child(status_instance)
	var index=effected_player.num_spells+get_child_count()-1
	status_instance.initialize(status,caster,effected_player,index)
	

func get_held_time(index:int):
	##print("getting held time of ",spell_index)
	return get_child(index-effected_player.num_spells).get_held_time()

func clear_status(index:int):
	for i in range(get_child_count()):
		if (i==index):
			get_child(i).queue_free()
		elif (i>index):
			get_child(i).lower_index()
