extends Area2D


func _on_Entrance_body_entered(_body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")
