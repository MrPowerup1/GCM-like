extends Node
class_name PlayerManager

var player_character:Player
var skin:CharacterSkin
var spawn_loc:SGFixedVector2=SGFixedVector2.new()
enum control_mode {ROUND_CONTROL,UI_CONTROL}
var current_mode = control_mode.UI_CONTROL
var device_id:int
var player_index:int
@export var spell_deck:Deck
@export var skin_deck:Deck

func _ready():
	player_character=%"Player Character"
	player_character.disable()
	player_character.new_auth(device_id)
	spell_deck=spell_deck.duplicate()

func add_controls(controls:Input_Keys):
	print("Adding controls, ", controls)
	player_character.add_input(controls)

func set_start_pos(position:Vector2):
	if position!=null:
		spawn_loc.from_float(position)

func start_round():
	player_character.enable()
	player_character.reset()
	player_character.fixed_position=spawn_loc
	print (player_character.fixed_position.to_float())
	GameManager.alive_players.append(self)
	current_mode=control_mode.ROUND_CONTROL
	if player_character.my_input!=null:
		player_character.my_input.current_mode=PlayerCharacterInput.input_mode.GAMEPLAY
		player_character.my_input.input_mode_changed.emit(player_character.my_input.current_mode)
	
func stop_round():
	player_character.disable()
	current_mode=control_mode.UI_CONTROL
	if player_character.my_input!=null:
		player_character.my_input.current_mode=PlayerCharacterInput.input_mode.UI
		player_character.my_input.input_mode_changed.emit(player_character.my_input.current_mode)

func set_skin(new_skin:CharacterSkin):
	skin=new_skin
	player_character.set_skin(new_skin)

func set_spell(new_spell:Spell):
	if new_spell==null:
		player_character.unequip_spell()
	else:
		player_character.equip_spell(new_spell)
