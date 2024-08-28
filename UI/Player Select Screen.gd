extends GridContainer
class_name	PlayerSelectScreen

@export var player_panel:PackedScene
@export var max_players:int = 4
@export var min_players:int = 2
var most_recent_panel:PlayerPanel
var current_players=0
var starting:bool = false

signal players_ready()
signal players_unready()
signal player_quit(player:PlayerUIInput)

func _ready():
	new_panel()

func _on_player_joined():
	if !starting and current_players < max_players:
		current_players+=1
		if (current_players < max_players):
			new_panel()
			print(current_players)
		else:
			pass
		
	else:
		print ("Too many players")	


func _on_player_quit():
	current_players-=1
	#print("Player Quit")
	#Timer because there seemed to be a race condition on signal emissions
	await get_tree().create_timer(0.1).timeout
	_on_player_ready()

func _on_player_ready():
	print(current_players)
	if current_players >= min_players:
		print("a player is ready")
		for panel in get_children():
			if panel is PlayerPanel and !((panel as PlayerPanel).now_ready):# or (panel as PlayerPanel).current_style==PlayerPanel.style.AWAIT_PLAYER):
				return
		for panel in get_children():
			if panel is PlayerPanel and !(panel as PlayerPanel).attached_player:
				panel.queue_free()
		players_ready.emit()
		starting=true

func _on_player_unready():
	if starting and current_players < max_players:
		new_panel()
	players_unready.emit()
	starting=false
	

func new_panel():
	if get_child_count() < current_players + 1:
		most_recent_panel =  player_panel.instantiate()
		add_child(most_recent_panel,true)
		most_recent_panel.player_ready.connect(_on_player_ready)
		most_recent_panel.player_quit.connect(_on_player_quit)
		most_recent_panel.player_unready.connect(_on_player_unready)
		most_recent_panel.player_joined.connect(_on_player_joined)

#func reset_panels():
	#for child in get_children():
		#if child is PlayerPanel and child.now_ready:
			##print("resetting")
			#(child as PlayerPanel).reset()


func _on_player_panel_1_player_joined():
	pass # Replace with function body.
