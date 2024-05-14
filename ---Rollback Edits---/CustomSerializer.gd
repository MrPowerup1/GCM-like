extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"


const input_path_mapping = {
	"/root/Test Level/PlayerManager/Player Character/PlayerCharacterInput":1,
	"/root/Test Level/PlayerManager2/Player Character/PlayerCharacterInput":2,
	"/root/Test Level/PlayerManager3/Player Character/PlayerCharacterInput":3,
	"/root/Test Level/PlayerManager4/Player Character/PlayerCharacterInput":4,
	"/root/Test Level/PlayerManager5/Player Character/PlayerCharacterInput":5,
	"/root/Test Level/PlayerManager6/Player Character/PlayerCharacterInput":6,
}

enum HeaderFlags {
	HAS_INPUT_VECTOR = 0x01
}

var input_path_mapping_reverse := {}

func _init() -> void:
	for key in input_path_mapping:
		input_path_mapping_reverse[input_path_mapping[key]] = key

func serialize_input(all_input: Dictionary) -> PackedByteArray:
	
	var buffer := StreamPeerBuffer.new()
	buffer.resize(16)
	#state hash
	buffer.put_u32(all_input['$'])
	#flag for number of players inputs, -1 for the hash
	buffer.put_u8(all_input.size()-1)
	
	for path in all_input:
		if path == '$':
			continue
		buffer.put_u8(input_path_mapping[path])
		var header := 0
		
		var input = all_input[path]
		
		if input.has('input_vector'):
			#Set header flag with bitwise OR
			header |= HeaderFlags.HAS_INPUT_VECTOR
		buffer.put_u8(header)
		
		if input.has('input_vector'):
			var input_vector: SGFixedVector2 = input['input_vector']
			buffer.put_64(input_vector.x)
			buffer.put_64(input_vector.y)
	
	buffer.resize(buffer.get_position())
	return buffer.data_array

func unserialize_input(serialized: PackedByteArray) -> Dictionary:
	var buffer := StreamPeerBuffer.new()
	buffer.put_data(serialized)
	buffer.seek(0)
	
	var all_input := {}
	
	all_input['$']= buffer.get_u32()
	
	var input_count=buffer.get_u8()
	
	for i in range(input_count):
		var path = input_path_mapping_reverse[buffer.get_u8()]
		var input = {}
		var header = buffer.get_u8()
		#Check for input vector with bitwise and
		if header & HeaderFlags.HAS_INPUT_VECTOR:
			input["input_vector"] = SGFixed.vector2(buffer.get_64(),buffer.get_64())
		all_input[path] = input
		
	return all_input
