extends Node
class_name Level

func get_starting_positions(player_count:int)->Array[SGFixedVector2]:
	if player_count ==2:
		return [$"Player Spawn Manager/2 Player/1".fixed_position,$"Player Spawn Manager/2 Player/2".fixed_position]
	if player_count ==3:
		return [$"Player Spawn Manager/3 Player/1".fixed_position,$"Player Spawn Manager/3 Player/2".fixed_position,$"Player Spawn Manager/3 Player/3".fixed_position]
	if player_count ==4:
		return [$"Player Spawn Manager/4 Player/1".fixed_position,$"Player Spawn Manager/4 Player/2".fixed_position,$"Player Spawn Manager/4 Player/3".fixed_position,$"Player Spawn Manager/4 Player/4".fixed_position]
	return []
