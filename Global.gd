extends Node2D

var player_initial_map_position = Vector2(50,50)
var player_direction = ["LEFT","RIGHT","UP","DOWN"]
var player_velocity = Vector2()
var player_speed

var player_isIdle : bool
var player_isWalking : bool
var player_isRunning : bool
var player_isUsing : bool
var player_isShooting : bool

var player_pickedUpItem : bool
var player_DropItem : bool

var pressed_button

var hasM4a1 : bool
var hasMiningDrill : bool

