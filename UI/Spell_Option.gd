extends PanelContainer

@export var spell:Spell_Type
#var image_ref:TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	#image_ref=%Skin
	%Skin.texture=spell.card_image
	%Name.text = spell.name
	%Description.text=spell.description


func set_new_spell (new_spell:Spell_Type):
	spell=new_spell
	%Skin.texture=spell.card_image
	%Name.text = spell.name
	%Description.text=spell.description
	
