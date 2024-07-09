extends PanelContainer
class_name CardDisplay

@export var card:Card
enum DisplayStyle {ZOOMED,ICON,STANDARD,TINY}
@export var current_style:DisplayStyle
#var image_ref:TextureRect

func _ready():
	reset_shader()

func reset_shader():
	%Image.material = %Image.material.duplicate(true)

func set_new_card (new_card:Card):
	if new_card ==null:
		return
	card=new_card
	new_card.display(self)
	
func set_cardname(new_name:String):
	%CardName.text=new_name

func set_description(description:String):
	%ShortDescription.text=description

func set_image(image:Texture2D):
	%Image.texture=image	

func set_theme_type(new_theme):
	theme_type_variation=new_theme

func set_shader_replacement_color(new_color:Color):
	%Image.material.set_shader_parameter("new_color",new_color)

func set_display_style(new_style:DisplayStyle):
	if new_style==DisplayStyle.ICON:
		%CardName.visible=false
		%ShortDescription.visible=false
		%Image.visible=true
	if new_style==DisplayStyle.ZOOMED:
		%CardName.visible=true
		%ShortDescription.visible=true
		%Image.visible=true
	if new_style==DisplayStyle.STANDARD:
		%CardName.visible=true
		%ShortDescription.visible=false
		%Image.visible=true
	if new_style==DisplayStyle.TINY:
		%CardName.visible=false
		%ShortDescription.visible=false
		%Image.visible=true
	current_style=new_style
