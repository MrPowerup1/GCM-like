extends Node
class_name PlayerManager

var player_character:Player
var skin:CharacterSkin
@export var spawn_loc:Vector2
enum control_mode {ROUND_CONTROL,UI_CONTROL}
var current_mode = control_mode.UI_CONTROL

func _ready():
	player_character=%"Player Character"
	player_character.disable()

func add_controls(controls:Input_Keys):
	player_character.my_input.input_keys=controls

func set_start_pos(position:Vector2):
	spawn_loc=position

func start_round():
	player_character.enable()
	player_character.position=spawn_loc
	current_mode=control_mode.ROUND_CONTROL
	player_character.my_input.current_mode=PlayerCharacterInput.input_mode.GAMEPLAY
	player_character.my_input.input_mode_changed.emit(player_character.my_input.current_mode)
	
func stop_round():
	player_character.disable()
	current_mode=control_mode.UI_CONTROL
	player_character.my_input.current_mode=PlayerCharacterInput.input_mode.UI
	player_character.my_input.input_mode_changed.emit(player_character.my_input.current_mode)

func set_skin(new_skin:CharacterSkin):
	skin=new_skin
	player_character.set_skin(new_skin)

func set_spell(index:int,new_spell:Spell_Type):
	player_character.equip_spell(new_spell,index)
