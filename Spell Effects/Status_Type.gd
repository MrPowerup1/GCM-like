extends Resource
class_name Status_Type

@export var on_activate:Spell_Effect
@export var on_held:Spell_Effect
@export var on_release:Spell_Effect
#the held function will be called repeatedly while still held, based on timer
@export var ping_time:float
@export var total_effect_time:float


func activate(caster:Player,spell_index:int):
	on_activate.trigger(caster,spell_index)
func held(caster:Player,spell_index:int):
	on_held.trigger(caster,spell_index)
func release(caster:Player,spell_index:int):
	on_release.trigger(caster,spell_index)
