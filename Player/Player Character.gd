extends CharacterBody2D
class_name Player

@export var health:int = 10
var can_release:Array[bool]=[true,true]
var can_cast:Array[bool]=[true,true]
var facing:Vector2
var num_spells:int
@export var my_input:PlayerCharacterInput

signal spell_activated(index:int)
signal spell_released(index:int)

func _ready():
	my_input.button_activate.connect(activate)
	my_input.button_release.connect(release)
	#Seperate the material so it doesn't change with others
	%Sprite2D.material = %Sprite2D.material.duplicate(true)

func _physics_process(delta):
	
	if %Velocity.can_move and !velocity.is_zero_approx():
		facing=velocity.normalized().snapped(Vector2.ONE)
 
func activate(index:int):
	if can_cast[index]:
		%"Spell Manager".activate(index)
		spell_activated.emit(index)
	
func release(index:int):
	if can_release[index]:
		%"Spell Manager".release(index)
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

func set_skin(new_skin:CharacterSkin):
	#Commented out to test smaller skin version
	%Sprite2D.texture=new_skin.texture
	%Sprite2D.material.set_shader_parameter("new_color",new_skin.color)
	
func equip_spell(new_spell:Spell):
	if !%"Spell Manager".known_spells.has(new_spell):
		%"Spell Manager".learn_spell(new_spell)
	%"Spell Manager".equip_spell(%"Spell Manager".known_spells.find(new_spell))

func unequip_spell():
	%"Spell Manager".unequip_spell()
