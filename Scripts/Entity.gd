extends CharacterBody3D

var health_pickup = load("res://HealthPickup.tscn")
var shotgun_pickup = load("res://ShotgunPickup.tscn")
var pistol_pickup = load("res://PistolPickup.tscn")

var PICK_UPS = [health_pickup, shotgun_pickup, pistol_pickup, null]

const INIT_MOVESPD = 5.0
var move_speed = INIT_MOVESPD

enum types_of_mons {
	SLIME
}

var hp = 100

func damage(dmg, blood_splatter: bool, is_player=true):
	self.hp -= dmg
	if blood_splatter == true:
		get_node("./Blood/BloodSplatter").visible = true
		get_node("./Blood/BloodAnim").play("blood_splatter")
	if is_player:
		self.get_node("HPCooldown").start()
		self.can_be_damaged = false

func die(collision_shape: CollisionShape3D, anim_player: AnimationPlayer, anim_name: String):
	collision_shape.disabled = true
	anim_player.play(anim_name)
	var can_drop = randi_range(0,1)
	if can_drop == 0:
		return
	var pick_up = PICK_UPS[randi_range(0,PICK_UPS.size()-1)]
	if pick_up == null:
		return
	else:
		drop_pickup(pick_up)

func drop_pickup(pickup):
	self.add_child(pickup.instantiate())
