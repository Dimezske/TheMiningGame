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

onready var inventory = get_tree().get_root().get_node("Game/World/YSort/Character/UserInterface/Inventory")
onready var grid = inventory.get_child(2)



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
	if player_in_range and event.is_action_pressed("interact"):
		for i in grid.get_child_count():
			if(grid.get_child(i).item and grid.get_child(i).item.item_name == "MineRocks"):
				grind_item(grid.get_child(i).item, i)
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
		
func grind_item(item, i):
	var item_drop = preload("res://ItemDrop.tscn").instance()
	item_drop.init(item)
	var player = get_tree().current_scene.find_node("Player", true)
#	item_drop.global_position = player.global_position + Vector2(40,-25)
	item_drop.global_position = Vector2(0,0)
	$Path2D/PathFollow2D.add_child(item_drop)
	
	PlayerInventory.remove_item(grid.get_child(i))
	grid.get_child(i).pickFromSlot()
	var x = inventory.find_parent("UserInterface").get_child(inventory.find_parent("UserInterface").get_child_count() - 1)
	inventory.find_parent("UserInterface").remove_child(x)
	#grid.get_child(i).remove_child(item)
	#grid.get_child(i).queue_free()
	
		
func _on_PlaceRocks_body_entered(body):
	if body.name == "Player":
		print("player detected")
		player_in_range = true
		
func _on_PlaceRocks_body_exited(body):
	if body.name == "Player":
		player_in_range = false
