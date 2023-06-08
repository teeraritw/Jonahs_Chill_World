extends "res://Scripts/Entity.gd"

const MOVE_SPEED = 16
const MOUSE_SENS = 0.2
 
const INIT_PISTOL_AMMO = 20
const INIT_SHOTGUN_AMMO = 6
var pistol_ammo = INIT_PISTOL_AMMO
var shotgun_ammo = INIT_SHOTGUN_AMMO

@onready var anim_player = $AnimationPlayer
@onready var raycast = $RayCast3D
@onready var gun_audio = $GunAudio
@onready var ammo_amount = $CanvasLayer/Ammo/AmmoAmount

var ammo_list = {"Fist": -1,"Pistol":pistol_ammo,"Shotgun":shotgun_ammo}

const WEAPON_LIST = ["Fist","Pistol","Shotgun"]
var current_weapon = WEAPON_LIST[0]
var dmg = 0
var can_be_damaged = true

const MAX_HP = 100

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
 
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x


func _physics_process(delta):
	var current_ammo = int(ammo_amount.text)
	get_tree().call_group("monsters", "set_player", self)
	if current_ammo == 0:
		ammo_amount.add_theme_color_override("font_color",Color(255,0,0))
	elif current_ammo > 0 and current_ammo <= 4:
		ammo_amount.add_theme_color_override("font_color", Color(255,255,0))
	else:
		ammo_amount.add_theme_color_override("font_color",Color(255,255,255))
	# if current_weapon is fist
	if current_weapon == WEAPON_LIST[0]:
		ammo_amount.text = ""
	# if not, update like normal
	else:
		ammo_amount.text = str(ammo_list[current_weapon])
	if hp <= 0:
		get_tree().reload_current_scene()
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
	if Input.is_action_just_pressed("fist") and current_weapon != WEAPON_LIST[0]:
		get_node("./CanvasLayer/Control/"+current_weapon).visible = false
		current_weapon = WEAPON_LIST[0]
		$CanvasLayer/Control/Fist.visible = true
	elif Input.is_action_just_pressed("pistol") and current_weapon != WEAPON_LIST[1]:
		get_node("./CanvasLayer/Control/"+current_weapon).visible = false
		current_weapon = WEAPON_LIST[1]
		$CanvasLayer/Control/Pistol.visible = true
	elif Input.is_action_just_pressed("shotgun") and current_weapon != WEAPON_LIST[2]:
		get_node("./CanvasLayer/Control/"+current_weapon).visible = false
		current_weapon = WEAPON_LIST[2]
		$CanvasLayer/Control/Shotgun.visible = true
		
	################
	### ON SHOOT ###
	################
	if Input.is_action_just_pressed("shoot") and !anim_player.is_playing():
		gun_audio.volume_db = -20
		if ammo_list[current_weapon] == 0:
			return
		match current_weapon:
			WEAPON_LIST[0]:
				dmg = 50
				gun_audio.pitch_scale = 0.7
				gun_audio.volume_db = -30
				anim_player.play("punch")
			WEAPON_LIST[1]:
				dmg = 100
				gun_audio.pitch_scale = 0.2
				anim_player.play("shoot_pistol")
				print_debug(ammo_list.values()[1])
			WEAPON_LIST[2]:
				dmg = 200
				gun_audio.pitch_scale = 0.1
				anim_player.play("shoot_shotgun")
		ammo_list[current_weapon]-=1
		gun_audio.play()
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("damage"):
			coll.damage(dmg, true,false)


func _on_hp_cooldown_timeout():
	can_be_damaged = true
