extends CharacterBody3D
 
const MOVE_SPEED = 16
const MOUSE_SENS = 0.2
 
@onready var anim_player = $AnimationPlayer
@onready var raycast = $RayCast3D
@onready var gun_audio = $GunAudio

const weapon_list = ["Fist","Pistol","Shotgun"]
var current_weapon = weapon_list[0]
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	await get_tree().create_timer(1).timeout
	get_tree().call_group("zombies", "set_player", self)
 
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
 
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()
 
func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("forward"):
		move_vec.x -= 1
	if Input.is_action_pressed("backward"):
		move_vec.x += 1
	if Input.is_action_pressed("left"):
		move_vec.z += 1
	if Input.is_action_pressed("right"):
		move_vec.z -= 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)
	if (move_vec.x != 0 or move_vec.z != 0) and !$WalkAudio.playing:
		$WalkAudio.play()
	######################
	### SWITCH WEAPONS ###
	######################
	if Input.is_action_just_pressed("fist") and current_weapon != weapon_list[0]:
		get_node("./CanvasLayer/Control/"+current_weapon).visible = false
		current_weapon = weapon_list[0]
		$CanvasLayer/Control/Fist.visible = true
	elif Input.is_action_just_pressed("pistol") and current_weapon != weapon_list[1]:
		get_node("./CanvasLayer/Control/"+current_weapon).visible = false
		current_weapon = weapon_list[1]
		$CanvasLayer/Control/Pistol.visible = true
	elif Input.is_action_just_pressed("shotgun") and current_weapon != weapon_list[2]:
		get_node("./CanvasLayer/Control/"+current_weapon).visible = false
		current_weapon = weapon_list[2]
		$CanvasLayer/Control/Shotgun.visible = true
		
	################
	### ON SHOOT ###
	################
	if Input.is_action_just_pressed("shoot") and !anim_player.is_playing():
		match current_weapon:
			weapon_list[0]:
				anim_player.play("punch")
				$Burp.play()
			weapon_list[1]:
				gun_audio.pitch_scale = 0.2
				gun_audio.play()
				anim_player.play("shoot_pistol")
			weapon_list[2]:
				gun_audio.pitch_scale = 0.1
				gun_audio.play()
				anim_player.play("shoot_shotgun")
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
 
func kill():
	get_tree().reload_current_scene()
