extends StaticBody2D
var player_in_range : bool
export var item_name = "MineRocks"
var quantity = 1
var player = null

enum{
	MOVE,
	GRINDING
}
export var SPEED = 100
var state = MOVE
var direction = Vector2.UP

func _ready():
	pass 
func _process(delta):
	match state:
		MOVE:
			move(delta)
			direction = choose([Vector2.UP,Vector2.DOWN])
			state = choose([MOVE, GRINDING])
		GRINDING:
			pass
func _on_PlaceRocks_body_entered(body):
	if body.name == "Character":
		print("player detected")
		player_in_range = true
		if Input.is_action_just_pressed("interact"):
			PlayerInventory.add_item(item_name, quantity)
			print("Testing rock")
			
func move(delta):
	position += direction * SPEED * delta

func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	$Timer.wait_time = choose([3.5, 6])
	state = choose([MOVE,GRINDING])
	
func _on_PlaceRocks_body_exited(body):
	if body.name == "Character":
		player_in_range = false
