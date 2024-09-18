extends CanvasLayer

signal restart
signal end

func _ready():
	%Skin.material = %Skin.material.duplicate(true)

func display_winner():
	var winner = GameManager.alive_players.values()[0]
	%Skin.texture=winner.skin.texture
	%Skin.material.set_shader_parameter("new_color",winner.skin.color)


func _on_restart_button_down() -> void:
	restart.emit()


func _on_end_button_down() -> void:
	end.emit()
