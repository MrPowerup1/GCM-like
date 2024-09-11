extends PanelContainer
class_name  StatusIcon
@export var image:Texture2D
	
@export var flash_on_ping:bool
@export var flash_color:Color
# Called when the node enters the scene tree for the first time.
func _ready():
	%TextureRect.texture=image
	##$PingTimer.wait_time = MathHelper.ticks_to_sec(ping_ticks)
	#$PingTimer.start()
	#$PercentTimer.wait_time = MathHelper.ticks_to_sec(effect_ticks)/10
	#$PercentTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_percent_timer_timeout():
	%StatusPercent.value-=10
	if %StatusPercent.value <=0:
		queue_free()


func _on_ping_timer_timeout():
	if flash_on_ping:
		flash(true)
		$FlashTimer.start()


func _on_flash_timer_timeout():
	flash(false)

func flash(state:bool):
	if state:
		%ColorRect.color=flash_color
	else:
		%ColorRect.color=Color.TRANSPARENT
