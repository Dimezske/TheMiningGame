extends Area2D
class_name Drill , "res://Assets/Tools/drill1.png"
var MiningDrill = preload("res://Items/MiningDrill_item.tscn")
const drillEffectsPath = preload("res://Items/SpriteEffects/DrillingEffects.tscn")
export(bool) var on_floor: bool = false
var parent_velocity = Vector2()
var velocity = Vector2()
var isDrilling : bool
var isLazer : bool
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _process(_delta):
		#look_at(get_global_mouse_position())
		_drills_input()
		_drills_animation()
		
func _drills_input():
	if Global.hasMiningDrill:
		if Input.is_action_just_pressed("use"):
			if $MiningDrill_Sound.playing == false:
				$MiningDrill_Sound.play()
				isDrilling = true
				drill() # == null
		if Input.is_action_pressed("use"):
			if $MiningDrill_Sound.playing == false:
				$MiningDrill_Sound.play()
				isDrilling = true
				drill() # == null
		else:
			isDrilling = false

func drill():
	var drill_effects_instance = drillEffectsPath.instance()
	print("Drilling")
	print(Global.player_direction)
	isDrilling = true 
	drill_effects_instance.position = $DrillEnd.get_global_position()
	get_tree().get_root().add_child(drill_effects_instance)
		
func _drills_animation():
	if parent_velocity != Vector2.ZERO:
		animationTree.set("parameters/IdleDrill/blend_position", parent_velocity.normalized())
		animationState.travel("IdleDrill")
		if isDrilling:
			animationState.travel("Drilling")
			animationTree.set("parameters/Drilling/blend_position", parent_velocity.normalized())
		else:
			animationTree.set("parameters/IdleDrill/blend_position", parent_velocity.normalized())
	else:
		animationState.travel("IdleDrill")
