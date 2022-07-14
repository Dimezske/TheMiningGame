extends Area2D

var items_in_range = {}

			
func _on_ItemPickupCollision_body_entered(body):
	items_in_range[body] = body
#	if body.is_in_group("Box"):
#		get_node("HUD/pickup_button").visible = true
#		get_node("HUD/pickup_button").modulate = Color(0.670588, 1, 0.839216)
	
func _on_ItemPickupCollision_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)
#	get_node("HUD/pickup_button").modulate = Color(0, 1, 0.501961)

