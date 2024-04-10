extends Spell_Effect
class_name Print_Effect

@export var message:String

func trigger(caster:Player,spell_index:int):
	print (message)


