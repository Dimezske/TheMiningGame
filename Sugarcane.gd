extends KinematicBody2D

#Sugarcane growing
#5 stages, grows over time, can be harvested when fully grown
enum{
	Growing,
	Grown
}
var stage = Growing

func _ready():
	$Sprite.texture = load("res://Assets/Agriculture/Sugarcane-3.png")
func _process(delta):
	match stage:
		Growing:
			grow(delta)
		Grown:
			$Timer.paused = true
func grow(delta):
	$Sprite.texture = load("res://Assets/Agriculture/Sugarcane-3.png")
	$Timer.wait_time = choose(Growing)
	$Sprite.texture = load("res://Assets/Agriculture/Sugarcane-4.png")
	$Timer.wait_time = 5
	$Sprite.texture = load("res://Assets/Agriculture/Sugarcane-full.png")
	$Timer.wait_time = 5
	print("fullyGrown")
	
func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	$Timer.wait_time = choose([5,1])
	stage = choose([Growing,Grown])
