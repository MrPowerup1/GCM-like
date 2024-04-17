extends Resource
class_name Status_Type

@export_subgroup("Define New Effects")
@export var on_activate:Spell_Effect
@export var on_held:Spell_Effect
@export var on_release:Spell_Effect
#the held function will be called repeatedly while still held, based on timer
@export var ping_time:float
@export var total_effect_time:float


func activate(caster:Player,spell_index:int):
	if(on_activate!=null):
		on_activate.trigger(caster,caster,spell_index)
func held(caster:Player,spell_index:int):
	if(on_held!=null):
		on_held.trigger(caster,caster,spell_index)
func release(caster:Player,spell_index:int):
	if(on_release!=null):
		on_release.trigger(caster,caster,spell_index)
