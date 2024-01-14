extends CharacterBody2D

const MOVE_SPEED = 100.0
const JUMP_VELOCITY = -400.0
const JUMP_SPEED = 150

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jump_pressed = 0
var game_start = true
var jump_direction = 0
var direction

# Load character sprite and animation player
@onready var anim_sprite = get_node("Sprite2D")
@onready var anim_player = get_node("AnimationPlayer")

func _physics_process(delta):
	if is_on_floor():
		var direction = Input.get_axis("ui_left", "ui_right")
		
		if direction != 0:
			jump_direction = direction
			anim_player.play("run")
			
			velocity.x = direction * MOVE_SPEED
			# Check the current direction and flip the sprite respectively
			if direction == 1:
				anim_sprite.flip_h = false
			elif direction == -1:
				anim_sprite.flip_h = true
		
		else:
			velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
			if(velocity.y == 0):
				anim_player.play("idle")
				
		if Input.is_action_pressed("ui_accept"):
			jump_pressed += (delta * 1.5)
			
		if Input.is_action_just_released("ui_accept"):
			if jump_pressed > 1.3:
				jump_pressed = 1.3
			
			velocity.y = jump_pressed * JUMP_VELOCITY
			velocity.x = jump_direction * JUMP_SPEED
			jump_pressed = 0

	else:
		velocity.y += gravity * delta
		
	
	move_and_slide()
