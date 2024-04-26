extends Node

@export var status_instance_scene:PackedScene
var effected_player:Player

func _ready():
	effected_player=get_parent()

func new_status(status:Status_Type,caster:Player):
	var status_instance=status_instance_scene.instantiate()
	add_child(status_instance)
	var index=effected_player.num_spells+get_child_count()-1
	status_instance.initialize(status,caster,effected_player,index)
	

func get_held_time(index:int):
	return get_child(index-effected_player.num_spells).get_held_time()

func clear_status(index:int):
	for i in range(get_child_count()):
		if (i==index):
			get_child(i).queue_free()
		elif (i>index):
			get_child(i).lower_index()
