extends CharacterBody3D

var health_pickup = load("res://Pickups/HealthPickup.tscn")
var shotgun_pickup = load("res://Pickups/ShotgunPickup.tscn")
var pistol_pickup = load("res://Pickups/PistolPickup.tscn")

var PICK_UPS = [health_pickup, shotgun_pickup, pistol_pickup]

var pickup_y = 0

const INIT_MOVESPD = 5.0
var move_speed = INIT_MOVESPD

var hp = 100

func set_pickup_y(y_level):
	pickup_y = y_level

func set_hp(new_hp):
	self.hp = new_hp

func set_movespeed(new_speed):
	move_speed = new_speed

func damage(dmg, blood_splatter: bool, is_player=true):
	if blood_splatter == true:
		get_node("./Blood/BloodSplatter").visible = true
		get_node("./Blood/BloodAnim").play("blood_splatter")
	if is_player:
		var hp_cooldown = self.get_node("HPCooldown")
		if hp_cooldown.time_left == 0.0:
			self.hp -= dmg
			hp_cooldown.start()
	else:
		self.hp -= dmg

func die(collision_shape: CollisionShape3D, anim_player: AnimationPlayer, anim_name: String):
	collision_shape.disabled = true
	anim_player.play(anim_name)
	var can_drop = randi_range(0,1)
	if can_drop == 0:
		return
	var pick_up = null
	if randi_range(0,100) <= 30:
		pick_up = shotgun_pickup
	elif randi_range(0,100) <= 60:
		pick_up = pistol_pickup
	elif randi_range(0,100) <= 40:
		pick_up = health_pickup
	if pick_up != null:
		drop_pickup(pick_up)

func drop_pickup(pickup):
	var dropped_pickup = pickup.instantiate()
	dropped_pickup.top_level = true
	dropped_pickup.position.y = pickup_y
	self.add_child(dropped_pickup)
