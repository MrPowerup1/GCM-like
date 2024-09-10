extends PanelContainer
class_name CardDisplay

@export var card:Card
enum DisplayStyle {ZOOMED,ICON,STANDARD,TINY,INVISIBLE,DISPLAYING}
@export var current_style:DisplayStyle #:
	#set(new_style):
		#if new_style==DisplayStyle.ICON:
			#visible=true
			#%CardName.visible=true
			#%DescriptionBox.visible=false
			#%Image.visible=true
			#%Image.custom_minimum_size = Vector2.ONE*zoom_pixels
			#set_theme_type("")
		#if new_style==DisplayStyle.ICON:
			#visible=true
			#%CardName.visible=true
			#%DescriptionBox.visible=false
			#%Image.visible=true
			#%Image.custom_minimum_size = Vector2.ONE*zoom_pixels
			#set_theme_type("")
		#if new_style==DisplayStyle.ZOOMED:
			#visible=true
			#%CardName.visible=true
			#%DescriptionBox.visible=true
			#%Image.visible=true
			#%Image.custom_minimum_size = Vector2.ONE*standard_pixels
			#newName.emit("")
			#set_theme_type("SpellPanel")
		#if new_style==DisplayStyle.STANDARD:
			#visible=true
			#%CardName.visible=false
			#%DescriptionBox.visible=false
			#%Image.visible=true
			#%Image.custom_minimum_size = Vector2.ONE*standard_pixels
			#set_theme_type("")
		#if new_style==DisplayStyle.TINY:
			#visible=true
			#%CardName.visible=false
			#%DescriptionBox.visible=false
			#%Image.visible=true
			#%Image.custom_minimum_size = Vector2.ONE*tiny_pixels
			#set_theme_type("")
		#if new_style==DisplayStyle.INVISIBLE:
			#visible=false
const standard_pixels = 32
const tiny_pixels = 16
const zoom_pixels = 64
#var image_ref:TextureRect

signal newName(name:String)

func _ready():
	reset_shader()

func reset_shader():
	if %Image !=null:
		%Image.material = %Image.material.duplicate(true)

func set_new_card (new_card:Card):
	if new_card ==null:
		return
	card=new_card
	new_card.display(self)
	
func set_cardname(new_name:String):
	%CardName.text=new_name
	newName.emit(new_name)

func set_description(description:String):
	%Description.text=description

func set_image(image:Texture2D):
	%Image.texture=image	

func set_theme_type(new_theme):
	theme_type_variation=new_theme

func set_shader_replacement_color(new_color:Color):
	%Image.material.set_shader_parameter("new_color",new_color)

func set_display_style(new_style:DisplayStyle):
	if new_style==DisplayStyle.ICON:
		visible=true
		%CardName.visible=true
		%DescriptionBox.visible=false
		%Image.visible=true
		%Image.custom_minimum_size = Vector2.ONE*zoom_pixels
		set_theme_type("")
		%ImageBorder.theme_type_variation = "ClearPanelContainer"
	if new_style==DisplayStyle.ZOOMED:
		visible=true
		%CardName.visible=true
		%DescriptionBox.visible=true
		%Image.visible=true
		%Image.custom_minimum_size = Vector2.ONE*standard_pixels
		#newName.emit("")
		%ImageBorder.theme_type_variation = "ClearPanelContainer"
		set_theme_type("SpellPanel")
	if new_style==DisplayStyle.STANDARD:
		visible=true
		%CardName.visible=false
		%DescriptionBox.visible=false
		%Image.visible=true
		%Image.custom_minimum_size = Vector2.ONE*standard_pixels
		%ImageBorder.theme_type_variation = "ClearPanelContainer"
		set_theme_type("")
	if new_style==DisplayStyle.TINY:
		visible=true
		%CardName.visible=false
		%DescriptionBox.visible=false
		%Image.visible=true
		%Image.custom_minimum_size = Vector2.ONE*tiny_pixels
		%ImageBorder.theme_type_variation = "ClearPanelContainer"
		set_theme_type("ClearPanelContainer")
		#newName.emit("")
	if new_style==DisplayStyle.INVISIBLE:
		visible=false
	if new_style==DisplayStyle.DISPLAYING:
		visible=true
		#%CardName.visible=true
		%DescriptionBox.visible=false
		%Image.visible=true
		%Image.custom_minimum_size = Vector2.ONE*standard_pixels
		%ImageBorder.theme_type_variation = ""
		set_theme_type("ClearPanelContainer")
		print("New displaying")
		%CardName.visible=true
	current_style=new_style
