extends Spell_Effect
class_name Sound_Effect

@export var sound:AudioStreamWAV
@export var description:String

func trigger(target,caster:Player,spell_index:int):
	SyncManager.play_sound(str(target.get_path)+":"+description,sound)
