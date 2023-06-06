extends "res://Scripts/Entity.gd"

@onready var raycast = $RayCast3D
@onready var anim_play = $AnimationPlayer

var player = null
var dead = false

func _ready():
	anim_play.play("walk")
	add_to_group("monsters")

func _physics_process(delta):
	if dead or player == null:
		return
	if hp <= 0:
		die($"CollisionShape3D",$"AnimationPlayer", "death")
		dead = true
	if !$Blood/BloodAnim.is_playing():
			$Blood/BloodSplatter.visible = false
	var vec_to_player = player.position - position
	vec_to_player = vec_to_player.normalized()
	raycast.target_position = vec_to_player * 1.5
	
	move_and_collide(vec_to_player*move_speed*delta)
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.kill()

func kill():
	dead = true
	$CollisionShape3D.disabled = true
	anim_play.play("death")

func set_player(p):
	player = p
