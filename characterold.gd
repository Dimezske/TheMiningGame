extends KinematicBody2D


export (int) var speed = 200
var velocity = Vector2()
var isHoldingTool : bool
var isDrilling : bool

#const MiningDrill1_Texture = preload("res://Assets/Tools/drill1-spritesheet.png")
onready var Tool: Node2D = get_node("Position2D/Tools")
#onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

onready var event
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	get_pickup()
	animation_gestion()
	
	#var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	#if mouse_direction.x > 0 and animated_sprite.flip_h:
		#animated_sprite.flip_h = false
	#elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		#animated_sprite.flip_h = true

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move-right"):
		velocity.x += 1
	if Input.is_action_pressed("move-left"):
		velocity.x -= 1
	if Input.is_action_pressed("move-down"):
		velocity.y += 1
	if Input.is_action_pressed("move-up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	for child in self.get_children():
		if child.is_in_group("Position2D/Tools"):
			child.animate(velocity)
			
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
		
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
	if Input.is_action_just_released("mousebuttonclick"):
		if isHoldingTool:
			print("End drilling")
			isDrilling = false
	if Input.is_action_just_pressed("mousebuttonclick"):
		if isHoldingTool:
			print("Drilling")
			isDrilling = true
		
func _input(event):
	pass
	
func get_pickup():
	if Input.is_action_just_pressed("interact"):
		for area in $ItemPickupCollision.get_overlapping_areas():
			if area.is_in_group("Tools"):
				area.get_parent().remove_child(area)
				area.position = Vector2(0,0)
				$Position2D/Tools.add_child(area)
				isHoldingTool = true
				
func animation_gestion():
	if isHoldingTool:
		var drilling_player = get_node("Position2D/Tools/MiningDrill/AnimationTree")
		var state_anim = drilling_player.get("parameters/playback")

		if velocity == Vector2.ZERO:
			$AnimationTree.get("parameters/playback").travel("Idle")
			drilling_player.set("parameters/Drilling/blend_position", velocity.normalized())
		else:
			$AnimationTree.get("parameters/playback").travel("Walk")
			$AnimationTree.set("parameters/IdleHold/blend_position", velocity)
			$AnimationTree.set("parameters/Walk/blend_position", velocity)
		if isDrilling:
			state_anim.travel("Drilling")
			drilling_player.set("parameters/Drilling/blend_position", velocity.normalized())
		else:
			state_anim.travel("IdleDrill")
			drilling_player.set("parameters/IdleDrill/blend_position", velocity.normalized())
	else:
		if velocity == Vector2.ZERO:
			$AnimationTree.get("parameters/playback").travel("Idle")
		else:
			$AnimationTree.get("parameters/playback").travel("Walk")
			$AnimationTree.set("parameters/Idle/blend_position", velocity)
			$AnimationTree.set("parameters/Walk/blend_position", velocity)

#onready var on_hand_sprite = $Tools/MineDrill
#func _unhandled_input(event):
	#if isHoldingTool:
		#$Tools/MineDrill.visible = true
		#if event.is_action_pressed("Cycle_Items"):
			#on_hand_sprite.texture = MiningDrill1_Texture
		#else:
			#$Tools/MineDrill.visible = false
			
