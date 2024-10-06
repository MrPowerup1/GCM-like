extends VBoxContainer
@export var keyboard:Texture2D
@export var joystick:Texture2D
@export var remote:Texture2D
@export var player_index_label:Label
@export var player_control_texture:TextureRect
var player_index:int:
	set(new_index):
		player_index_label.text=str(new_index)
		player_index = new_index
		update()
var player_name:String
enum device_type {KEYBOARD,JOYSTICK,REMOTE}
@export var device:device_type:
	set(new_control):
		if new_control==device_type.KEYBOARD:
			player_control_texture.texture=keyboard
		if new_control==device_type.JOYSTICK:
			player_control_texture.texture=joystick
		if new_control==device_type.REMOTE:
			player_control_texture.texture=remote
		device = new_control
@export var skin_visible:bool = true

func _ready():
	reset_shader()
	#update()
	%PlayerSkin.visible=skin_visible

func update():
	var peer_id = GameManager.players[player_index]['peer_id']
	#Update Control Type display
	if GameManager.local_players.has(player_index):
		device = GameManager.local_players[player_index]['input_keys']['device_type']
	else:
		device = device_type.REMOTE
	
	#Update Player Skin
	var skin_card = GameManager.universal_skin_deck.get_card(GameManager.players[player_index]["selected_skin"])
	%PlayerSkin.texture =skin_card.image
	set_shader_replacement_color(skin_card.skin.color)
	if peer_id!=1:
		%PlayerName.text = GameManager.peers[str(peer_id)]['name']
	if GameManager.players[player_index]['wins'] >0:
		%"Wins Panel".visible=true
		%"Win Count".text = str(GameManager.players[player_index]['wins'])
		if GameManager.get_most_wins_index().has(player_index):
			%Crown.visible = true
		else:
			%Crown.visible=false
	
	
func set_shader_replacement_color(new_color:Color):
	%PlayerSkin.material.set_shader_parameter("new_color",new_color)

func reset_shader():
	if %PlayerSkin !=null:
		%PlayerSkin.material = %PlayerSkin.material.duplicate(true)
