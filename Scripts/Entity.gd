extends CharacterBody3D

const INIT_MOVESPD = 5.0
var move_speed = INIT_MOVESPD

enum types_of_mons {
	SLIME
}

var hp = 100

func damage(dmg, blood_splatter: bool):
	self.hp -= dmg
	if blood_splatter == true:
		get_node("./Blood/BloodSplatter").visible = true
		get_node("./Blood/BloodAnim").play("blood_splatter")

func die(collision_shape: CollisionShape3D, anim_player: AnimationPlayer, anim_name: String):
	collision_shape.disabled = true
	anim_player.play(anim_name)
