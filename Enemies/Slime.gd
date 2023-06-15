extends "res://Scripts/Entity.gd"

@onready var raycast = $RayCast3D
@onready var anim_play = $AnimationPlayer

const DAMAGE = 10

var player = null
var dead = false

func _ready():
	anim_play.play("walk")
	set_pickup_y(0.2)
	add_to_group("monsters")
	self.position.y += 0.4

func _physics_process(delta):
	if dead or player == null:
		return
	if hp <= 0:
		die($"CollisionShape3D",$"AnimationPlayer", "death")
		dead = true
		self.position.y=1.5
	if !$Blood/BloodAnim.is_playing():
			$Blood/BloodSplatter.visible = false
	var vec_to_player = player.position - position
	vec_to_player = vec_to_player.normalized()
	raycast.target_position = vec_to_player * 1.5
	
	move_and_collide(vec_to_player*move_speed*delta)
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.damage(DAMAGE,false)

func set_player(p):
	player = p
