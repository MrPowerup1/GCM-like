extends SGCharacterBody2D
class_name Player

var can_release:Array[bool]=[true,true]
var can_cast:Array[bool]=[true,true]
#var facing:Vector2
var num_spells:int
var snap_to_0:int = 65536/100
@export var input:PlayerCharacterInput = null
var skin:CharacterSkin
var peer_id:int
var player_index:int
@export var spell_deck:Deck
@export var skin_deck:Deck


signal spell_activated(index:int)
signal spell_released(index:int)

func _network_preprocess(input: Dictionary) -> void:
	sync_to_physics_engine()
	
func _network_postprocess(frame_input:Dictionary) -> void:
	input.velocity.update_pos()

func _ready():
	#Seperate the material so it doesn't change with others
	%Sprite2D.material = %Sprite2D.material.duplicate(true)
	%"Player Status".init_health(%Health.max_health)
	input.button_activate.connect(activate)
	input.button_release.connect(release)
	#Is this really needed?
	new_auth(peer_id)
	skin_deck=GameManager.universal_skin_deck.duplicate()
	
func get_facing() -> int:
	return %Velocity.facing

func activate(index:int):
	if can_cast[index]:
		%"Spell Manager".activate.rpc(index)
		spell_activated.emit(index)
		%NetworkAnimationPlayer.play("Cast1")

func release(index:int):
	if can_release[index]:
		%"Spell Manager".release.rpc(index)
		spell_released.emit(index)
		#%NetworkAnimationPlayer.play("Idle")
	
func add_status_effect(status:Status_Type,caster:Player):
	%"Player Status".new_status(status,caster)
	
	
func anchor (set_anchor:bool=true):
	%Velocity.anchor(set_anchor)
	#%NetworkAnimationPlayer.play("Idle")

func get_held_time(spell_index:int):
	if spell_index < num_spells:
		return %"Spell Manager".get_held_time(spell_index)
	else:
		return %"Player Status".get_held_time(spell_index)

func get_cast_iteration(spell_index:int):
	%"Spell Manager".get_cast_iteration(spell_index)

func set_sprite(new_sprite:Texture2D):
	%Sprite2D.texture=new_sprite
	
func set_release_permission(index:int, state:bool):
	can_release[index]=state

func clear_status(index:int):
	%"Player Status".clear_status(index)

func enable():
	visible=true
	can_cast=[true,true]
	can_release=[true,true]
	anchor(false)

func disable():
	visible=false
	can_cast=[false,false]
	can_release=[false,false]
	anchor(true)

func set_skin(new_skin):
	#Commented out to test smaller skin version
	if new_skin is CharacterSkin:
		skin=new_skin
	elif new_skin is int:
		skin = skin_deck.get_card(new_skin).skin
	
	%Sprite2D.texture=skin.texture
	%Sprite2D.material.set_shader_parameter("new_color",skin.color)
	
func equip_spell(new_spell:Spell,index:int):
	if !%"Spell Manager".known_spells.has(new_spell):
		%"Spell Manager".learn_spell(new_spell)
	%"Spell Manager".equip_spell(%"Spell Manager".known_spells.find(new_spell),index)

func unequip_spell(index:int):
	%"Spell Manager".unequip_spell(index)

func add_input(keys:Input_Keys):
	input.input_keys=keys
	input.velocity=%Velocity
	input.device=input.device_type.LOCAL

func new_auth(id:int):
	set_multiplayer_authority(id)
	input.set_multiplayer_authority(id)
	#%MultiplayerSynchronizer.set_multiplayer_authority(id)
	pass
	

func _save_state() ->Dictionary:
	return {
		position_x=fixed_position_x,
		position_y=fixed_position_y,
		health=%Health.current_health
	}

func _load_state(state:Dictionary) ->void:
	fixed_position_x = state['position_x']
	fixed_position_y = state['position_y']
	%Health.current_health=state['health']
	sync_to_physics_engine()
	
func reset():
	%Health.reset()
	for i in range(num_spells):
		unequip_spell(i)

func _on_health_dead():
	pre_despawn()
	%DespawnDelay.start()

func start_round():
	enable()
	GameManager.alive_players[player_index]=self
	
func stop_round():
	disable()


#var default_player_dict = {
			#"peer_id": -1,
			#"input_keys":base_input,
			#"known_spells": [0,1,2],
			#"selected_skin": 0,
			#"selected_spells":[],
			#"selected_level":-1
		#}
func _network_despawn() ->void:
	GameManager.alive_players.erase(player_index)
	print(GameManager.alive_players.size())
	#assert(%"Player Status".get_child_count()==0,"Child")

func pre_despawn()->void:
	%"Player Status".clear_status()
	for child in get_children():
		if child is DelayedCastInstance:
			SyncManager.despawn(child)

func _network_spawn(data: Dictionary) -> void:
	fixed_position_x=data['spawn_position_x']
	fixed_position_y=data['spawn_position_y']
	peer_id = data['peer_id']
	player_index = data['player_index']
	new_auth(peer_id)
	#input.input_keys= Input_Keys.from_dict(data['input_keys'])
	if not SyncReplay.active and peer_id == multiplayer.get_unique_id():
		input.input_keys = Input_Keys.from_dict(GameManager.local_players[player_index]['input_keys'])
	spell_deck=GameManager.universal_spell_deck.subdeck(data['known_spells'])
	set_skin(data['selected_skin'])
	var selected_spells = data['selected_spells']
	var index = 0 
	for spell_index in selected_spells:
		var new_spell = spell_deck.get_card(spell_index).spell
		equip_spell(new_spell,index)
		index+=1
	#GameManager.alive_players.append(self)
	sync_to_physics_engine()
	anchor(true)
	%NetworkAnimationPlayer.play("Walk")


func _on_despawn_delay_timeout():
	SyncManager.despawn(self)

func _interpolate_state(old_state:Dictionary, new_state:Dictionary, weight:float) -> void:
	fixed_position_x = lerp(old_state['position_x'],new_state['position_x'],weight)
	fixed_position_y = lerp(old_state['position_y'],new_state['position_y'],weight)
	
