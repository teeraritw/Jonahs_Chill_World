extends Area3D

var spawn_positions = []
var spawn_types = []
var amount_to_spawn = 2

@onready var slime = load("res://Slime.tscn")
@onready var ghost = load("res://Ghost.tscn")
@onready var flower = load("res://Flower.tscn")

@onready var player = get_node("../Player")
const SAFE_DISTANCE = 5

@onready var available_to_spawn = [slime,ghost,flower]

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
		if randi_range(0,100) <= 70:
			to_spawn = available_to_spawn[0]
		elif randi_range(0,100) <= 30:
			to_spawn = available_to_spawn[1]
		elif randi_range(0,100) <= 10:
			to_spawn = available_to_spawn[2]
		else:
			to_spawn = available_to_spawn[randi_range(0,available_to_spawn.size()-1)]
		spawn_types.insert(n,to_spawn)

func _on_timer_timeout():
	for n in amount_to_spawn:
		var pos = spawn_positions[n]
		var monster = spawn_types[n].instantiate()
		monster.position = pos
		get_tree().get_root().add_child(monster)
