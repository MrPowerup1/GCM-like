extends Status_Type
class_name Anchor_Status
#Do I even want to have a special anchor status? I guess it makes it easier instead of having to make a new one each time
@export_category("Set Total Effect Time to Anchor Time")
var anchor=Anchor_Effect.new()

func activate(caster:Player,spell_index:int):
	anchor.set_anchor_to=true
	anchor.trigger(caster,spell_index)
func held(caster:Player,spell_index:int):
	pass
func release(caster:Player,spell_index:int):
	anchor.set_anchor_to=false
	anchor.trigger(caster,spell_index)
