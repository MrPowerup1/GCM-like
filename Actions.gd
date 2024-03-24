extends Node
class_name Actions

@export var starting_spells:Array[Spell]=[]


# Called when the node enters the scene tree for the first time.
func _ready():
	if starting_spells != null and starting_spells.size()>0:
		for spell in starting_spells:
			var new_spell = spell.spell_scene.instantiate()
			add_child(new_spell)
			get_parent().add_spell(new_spell)
			new_spell.initialize(spell)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
