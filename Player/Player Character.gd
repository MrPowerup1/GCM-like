extends SGCharacterBody2D
class_name Player

@export var health:int = 10
var can_release:Array[bool]=[true,true]
var can_cast:Array[bool]=[true,true]
var facing:Vector2
var num_spells:int
var snap_to_0:int = 65536/100
@export var input:PlayerCharacterInput = null
var skin:CharacterSkin
var spawn_loc:SGFixedVector2=SGFixedVector2.new()
var device_id:int
var player_index:int
@export var spell_deck:Deck
@export var skin_deck:Deck


signal spell_activated(index:int)
signal spell_released(index:int)

func _ready():
	
	#Seperate the material so it doesn't change with others
	%Sprite2D.material = %Sprite2D.material.duplicate(true)
	%"Player Status".init_health(%Health.max_health)
	input.button_activate.connect(activate)
	input.button_release.connect(release)
	#Is this really needed?
	disable()
	new_auth(device_id)
	spell_deck=spell_deck.duplicate()
	

func _physics_process(delta):
	if %Velocity.can_move and (velocity.length_squared() > snap_to_0):
		facing=velocity.normalized().to_float().snapped(Vector2.ONE)
 

func activate(index:int):
	if can_cast[index]:
		%"Spell Manager".activate.rpc(index)
		spell_activated.emit(index)

func release(index:int):
	if can_release[index]:
		%"Spell Manager".release.rpc(index)
		spell_released.emit(index)
	
func add_status_effect(status:Status_Type,caster:Player):
	%"Status Manager".new_status(status,caster)

#TODO: REDO WITH COMPONENTS
func take_damage (amount:int):
	health-=amount
	
func anchor (set_anchor:bool=true):
	%Velocity.anchor(set_anchor)

#TODO: REDO WITH COMPONENTS
func heal (amount:int):
	health+=amount

func get_held_time(spell_index:int):
	if spell_index < num_spells:
		return %"Spell Manager".get_held_time(spell_index)
	else:
		return %"Status Manager".get_held_time(spell_index)

func set_sprite(new_sprite:Texture2D):
	%Sprite2D.texture=new_sprite
	
func set_release_permission(index:int, state:bool):
	can_release[index]=state

func clear_status(index:int):
	%"Status Manager".clear_status(index-num_spells)

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
		velocity_x=%Velocity.velocity.x,
		velocity_y=%Velocity.velocity.y
	}

func _load_state(state:Dictionary) ->void:
	fixed_position_x = state['position_x']
	fixed_position_y = state['position_y']
	velocity.x=state['velocity_x']
	velocity.y=state['velocity_y']
	sync_to_physics_engine()
	
func reset():
	%Health.reset()
	for i in range(num_spells):
		unequip_spell(i)

func _on_health_dead():
	GameManager.alive_players.erase(get_parent())

func start_round():
	new_auth(device_id)
	enable()
	reset()
	fixed_position=spawn_loc
	GameManager.alive_players.append(self)
	
func stop_round():
	disable()

#func from_dict(player_data:Dictionary):
	#print(player_data['player_data'].get('known_spells',[]))
	#spell_deck=GameManager.universal_spell_deck.subdeck(player_data['player_data'].get('known_spells',[]))
	#skin_deck = GameManager.universal_skin_deck
	#set_skin(skin_deck.get_card(player_data['player_data'].get('selected_skin',0)).skin)
	#for spell_index in player_data['match_data'].get('selected_spells'):
		#set_spell(spell_deck.get_card(spell_index).spell)
#
#func to_dict()-> Dictionary:
	##TODO: Change to actual player data
	#return  {
			#"player_data": {
				#"known_spells": [0,1,2],
				#"selected_skin": 0
			#},
			#"match_data": {
				##TODO: FIX Garbage Data
				#"selected_spells":[0,1],
				#"selected_level":[0]
			#}
		#}
	#
