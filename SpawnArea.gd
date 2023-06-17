extends Area3D

var spawn_positions = []
var spawn_types = []
var amount_to_spawn = 2

@onready var slime = load("res://Enemies/Slime.tscn")
@onready var ghost = load("res://Enemies/Ghost.tscn")
@onready var flower = load("res://Enemies/Flower.tscn")
@onready var pumpking = load("res://Enemies/Pumpking.tscn")
#@onready var bee = load("res://Enemies/Bee.tscn")
@onready var bat = load("res://Enemies/Bat.tscn")
@onready var eyeball = load("res://Enemies/Eyeball.tscn")

@onready var player = get_node("../Player")
const SAFE_DISTANCE = 5

@onready var available_to_spawn = [slime,bat,ghost,pumpking,eyeball,flower]

@onready var area_extent_x = self.scale.x/2
@onready var area_extent_z = self.scale.z/2

func _process(delta):
	spawn_positions = []
	spawn_types = []
	for n in amount_to_spawn:
		### SETTING POSITIONS ###
		var spawn_pos = Vector3(randf_range(-area_extent_x,area_extent_x),1.7,randf_range(-area_extent_z,area_extent_z))
		# check if position is within the player's "safe" distance
		while abs(spawn_pos.x - player.position.x) < SAFE_DISTANCE or abs(spawn_pos.z - player.position.z) < SAFE_DISTANCE:
			spawn_pos = Vector3(randf_range(-area_extent_x,area_extent_x),1.7,randf_range(-area_extent_z,area_extent_z))
		# add a spawn position within Area3D
		spawn_positions.insert(n,spawn_pos)
		
		var to_spawn = null
		### SETTING TYPES ###
		if randi_range(0,100) <= 55:
			to_spawn = slime
		elif randi_range(0,100) <= 40:
			to_spawn = bat
		elif randi_range(0,100) <= 35:
			to_spawn = eyeball
		elif randi_range(0,100) <= 35:
			to_spawn = ghost
		elif randi_range(0,100) <= 35:
			to_spawn = pumpking
		elif randi_range(0,100) <= 10:
			to_spawn = flower
		else:
			to_spawn = available_to_spawn[randi_range(3,available_to_spawn.size()-2)]
		spawn_types.insert(n,to_spawn)

func _on_timer_timeout():
	for n in amount_to_spawn:
		var pos = spawn_positions[n]
		var monster = spawn_types[n].instantiate()
		monster.position = pos
		get_tree().get_root().add_child(monster)
