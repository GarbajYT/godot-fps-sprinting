extends KinematicBody

var speed
var default_speed = 7
var sprint_speed = 14
var acceleration = 50
var gravity = 9.8
var jump = 5
var blink_dist = 15

var mouse_sensitivity = 0.03

var sprinting = false

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

onready var head = $Head
onready var sprint_timer = $SprintTimer

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _process(delta):
	
	speed = default_speed
	
	direction = Vector3()
	
	if not is_on_floor():
		fall.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		
	if Input.is_action_just_pressed("ability") and not sprinting:
		sprinting = true
		sprint_timer.start()
	elif Input.is_action_just_pressed("ability") and sprinting:
		sprinting = false
		
	if sprinting:
		speed = sprint_speed
	
	if Input.is_action_pressed("move_forward"):
	
		direction -= transform.basis.z
			
	
	elif Input.is_action_pressed("move_backward"):
		
		direction += transform.basis.z
			
		
	if Input.is_action_pressed("move_left"):
		
		direction -= transform.basis.x
			
		
	elif Input.is_action_pressed("move_right"):
		
		direction += transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 
	move_and_slide(fall, Vector3.UP)

func _on_SprintTimer_timeout():
	sprinting = false
