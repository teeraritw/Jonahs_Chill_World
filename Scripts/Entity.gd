extends CharacterBody3D

var health_pickup = load("res://HealthPickup.tscn")

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
	self.add_child(health_pickup.instantiate())
