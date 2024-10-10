extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"


const input_path_mapping = {
	"/root/Match/Players/Player1/PlayerCharacterInput":1,
	"/root/Match/Players/Player2/PlayerCharacterInput":2,
	"/root/Match/Players/Player3/PlayerCharacterInput":3,
	"/root/Match/Players/Player4/PlayerCharacterInput":4,
	"/root/Match/Players/Player5/PlayerCharacterInput":5,
	"/root/Match/Players/Player6/PlayerCharacterInput":6,
}

enum HeaderFlags {
	HAS_INPUT_VECTOR = 1<<0,
	SPELL_1_CAST = 1<<1,
	SPELL_1_RELEASE = 1<<2,
	SPELL_2_CAST = 1<<3,
	SPELL_2_RELEASE = 1<<4,
	MELEE_CAST = 1<<5,
	MELEE_RELEASE = 1<<6,
	MOBILITY_CAST = 1<<7,
	MOBILITY_RELEASE = 1<<8,
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
		if input.get('spell_1_pressed',false):
			header |= HeaderFlags.SPELL_1_CAST
		if input.get('spell_1_released',false):
			header |= HeaderFlags.SPELL_1_RELEASE
		if input.get('spell_2_pressed',false):
			header |= HeaderFlags.SPELL_2_CAST
		if input.get('spell_2_released',false):
			header |= HeaderFlags.SPELL_2_RELEASE
		if input.get('melee_pressed',false):
			header |= HeaderFlags.MELEE_CAST
		if input.get('melee_released',false):
			header |= HeaderFlags.MELEE_RELEASE
		if input.get('mobility_pressed',false):
			header |= HeaderFlags.MOBILITY_CAST
		if input.get('mobility_released',false):
			header |= HeaderFlags.MOBILITY_RELEASE
		buffer.put_u16(header)
		
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
		if header & HeaderFlags.SPELL_1_CAST:
			input['spell_1_pressed']=true
		if header & HeaderFlags.SPELL_1_RELEASE:
			input['spell_1_released']=true
		if header & HeaderFlags.SPELL_2_CAST:
			input['spell_2_pressed']=true
		if header & HeaderFlags.SPELL_2_RELEASE:
			input['spell_2_released']=true
		if header & HeaderFlags.MELEE_CAST:
			input['melee_pressed']=true
		if header & HeaderFlags.MELEE_RELEASE:
			input['melee_released']=true
		if header & HeaderFlags.MOBILITY_CAST:
			input['mobility_pressed']=true
		if header & HeaderFlags.MOBILITY_RELEASE:
			input['mobility_released']=true
		all_input[path] = input
		
	return all_input
