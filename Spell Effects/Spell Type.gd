extends Resource
class_name Spell_Type

@export_category("Effects")
@export var on_activate:Spell_Effect
@export var on_held:Spell_Effect
@export var on_release:Spell_Effect
@export var on_success:Spell_Effect
#the held function will be called repeatedly while still held, based on timer
@export_category("Timers (in milliseconds)")
@export var ping_asap:bool
@export var held_ping_time:float
@export var cooldown_time:float
#@export var max_charge_time:float
@export_category("UI and Internal")
@export var name:String
@export var card_image:Texture2D
@export_multiline var description:String
@export var element:Element
@export var requirements:Array[Element] = []
@export_enum("Passive","Active") var category:int
@export_enum("Buff","Movement","Attack","Defense") var type:int
#@export var spell_scene:PackedScene


func activate(caster:Player,spell_index:int):
	if(on_activate!=null):
		on_activate.trigger(caster,spell_index)
func held(caster:Player,spell_index:int):
	if(on_held!=null):
		on_held.trigger(caster,spell_index)
func release(caster:Player,spell_index:int):
	if(on_release!=null):
		on_release.trigger(caster,spell_index)
#func success(caster:Player,spell_index:int):
	#on_success.trigger(caster,spell_index)
