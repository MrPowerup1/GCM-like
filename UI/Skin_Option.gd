extends PanelContainer

@export var skin:CharacterSkin
var image_ref:TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	image_ref=%Skin
	%Skin.texture=skin.texture
	%Skin.material.set_shader_parameter("new_color",skin.color)
	%Name.text = skin.name


func set_new_skin (new_skin:CharacterSkin):
	%Skin.texture=new_skin.texture
	%Skin.material.set_shader_parameter("new_color",new_skin.color)
	%Name.text = new_skin.name
	skin=new_skin
