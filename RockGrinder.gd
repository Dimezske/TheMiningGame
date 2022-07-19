extends StaticBody2D
var player_in_range : bool
export var item_name = "MineRocks"
var quantity = 1
var player = null
onready var inventory = get_tree().get_root().get_node("Game/World/YSort/Character/UserInterface/Inventory")
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
func move(delta):
	position += direction * SPEED * delta

func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	$Timer.wait_time = choose([3.5, 6])
	state = choose([MOVE,GRINDING])
	
func _input(event):
	if event.is_action_pressed("interact") and player_in_range:
		if event.is_action_pressed("interact"):
			var grid = inventory.get_child(2)
			for i in grid.get_child_count():
				if(grid.get_child(i).item and grid.get_child(i).item.item_name == "MineRocks"):
					print("success")

func init(item):
	var new_item
	item_name = item.item_name
	quantity = item.item_quantity
	if item_name == "MineRocks" and player_in_range:
		item = new_item
		item.position = Vector2(0, 0)
		var placementNode = find_parent("PlaceCollison")
		placementNode.remove_child(item)
		add_child(item)
		$Sprite.texture = item.get_node("TextureRect").texture
		
func _on_PlaceRocks_body_entered(body):
	if body.name == "Player":
		print("player detected")
		player_in_range = true
		
func _on_PlaceRocks_body_exited(body):
	if body.name == "Player":
		player_in_range = false
