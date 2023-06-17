extends "res://Scripts/Entity.gd"

@onready var raycast = $RayCast3D
@onready var anim_play = $AnimationPlayer

var player = null
var dead = false

const HP = 2500
const MOVE_SPEED = 17
const Y_LEVEL = 3.8

func _ready():
	anim_play.play("walk")
	add_to_group("monsters")
	set_hp(HP)
	set_movespeed(MOVE_SPEED)
	set_pickup_y(-2)
	self.position.y = Y_LEVEL

func _physics_process(delta):
	if dead or player == null:
		return
	if hp <= 0:
		die($"CollisionShape3D",$"AnimationPlayer", "death")
		dead = true
		self.position.y = 3.8
		$Blood/BloodSplatter.visible = false
	if !$Blood/BloodAnim.is_playing():
			$Blood/BloodSplatter.visible = false
	var vec_to_player = player.position - position
	vec_to_player.y = 0
	vec_to_player = vec_to_player.normalized()
	$Blood/BloodSplatter.position = vec_to_player + Vector3(0.3,0,0.3)
	raycast.target_position = vec_to_player * 1.5
	
	move_and_collide(vec_to_player*move_speed*delta)
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.damage(60,false)

func set_player(p):
	player = p
