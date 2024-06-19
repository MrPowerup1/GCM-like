extends Node

@export var status_instance_scene:PackedScene
var effected_player:Player

func _ready():
	effected_player=get_parent()

func new_status(status:Status_Type,caster:Player):
	var index=effected_player.num_spells+get_child_count()-1
	var status_data = {
		status=status,
		caster=caster,
		effected_player=effected_player,
		#Is this needed?
		index=index
	}
	SyncManager.spawn('Status',self,status_instance_scene,status_data)
	

func get_held_time(index:int):
	return get_child(index-effected_player.num_spells).get_held_time()

func clear_status(index:int=-1):
	if index >=0:	
		for i in range(get_child_count()):
			if (i==index):
				SyncManager.despawn(get_child(i))
			elif (i>index):
				get_child(i).lower_index()
	else:
		for i in range(get_child_count()):
			get_child(i).queue_free()
