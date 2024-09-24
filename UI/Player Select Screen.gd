extends GridContainer
class_name	PlayerSelectScreen

@export var player_panel:PackedScene
@export var max_players:int = 4
@export var min_players:int = 2
@export var adding_new_players:bool = true

var most_recent_panel:PlayerPanel
var current_players=0
var starting:bool = false

signal players_ready()
signal players_unready()

func _ready():
	add_existing_players()
	update_panel_count()
	

func add_existing_players():
	current_players = GameManager.players.size()
	for player in GameManager.players.values():
		adding_new_players = false
		add_panel()
		print(player)
		most_recent_panel.add_player.rpc(player["player_index"])


func _on_player_joined(index:int):
	if !starting and current_players < max_players:
		current_players+=1
		update_panel_count()
		
	else:
		print ("Too many players")	


func _on_player_quit():
	current_players-=1
	#print("Player Quit")
	#Timer because there seemed to be a race condition on signal emissions
	await get_tree().create_timer(0.1).timeout
	check_all_ready()

func _on_player_ready():
	await get_tree().create_timer(0.1).timeout
	check_all_ready()

func check_all_ready():
	print("Checking ready")
	if current_players >= min_players:
		print("enough players")
		#print("a player is ready")
		for panel in get_children():
			if panel is PlayerPanel: 
				if ((panel as PlayerPanel).now_ready):
					pass
				elif !(panel as PlayerPanel).attached_player:
					print("player removed")
					panel.queue_free()
				else:
					print("not all players ready")
					return
		print("All Players READY!!!!")
		players_ready.emit()
		starting=true
	else:
		print("not_enough players")
func _on_player_unready():
	if starting:
		update_panel_count()
	players_unready.emit()
	starting=false
	

func update_panel_count():
	if adding_new_players and get_child_count() < current_players + 1 and current_players < max_players:
		add_panel()

func add_panel():
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
