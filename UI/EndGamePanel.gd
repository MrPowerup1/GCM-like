extends PanelContainer

func _ready():
	%Skin.material = %Skin.material.duplicate(true)

func end():
	var winner = GameManager.alive_players[0]
	%Skin.texture=winner.skin.texture
	%Skin.material.set_shader_parameter("new_color",winner.skin.color)
