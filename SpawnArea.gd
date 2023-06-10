extends Area3D

var spawn_positions = []
var spawn_types = []
var amount_to_spawn = 1
var pos_query = PhysicsPointQueryParameters3D.new()

@onready var slime = load("res://Slime.tscn")
@onready var ghost = load("res://Ghost.tscn")

@onready var available_to_spawn = [slime,ghost]

@onready var area_extent_x = self.scale.x/2
@onready var area_extent_z = self.scale.z/2

func _process(delta):
	spawn_positions = []
	spawn_types = []
	for n in amount_to_spawn:
		### SETTING POSITIONS ###
		var spawn_pos = Vector3(randf_range(-area_extent_x,area_extent_x),1.7,randf_range(-area_extent_z,area_extent_z))
		# check if position overlaps with the player's "safezone"
		var space_state = get_world_3d().direct_space_state
		pos_query.position = spawn_pos
		while !space_state.intersect_point(pos_query).is_empty():
			spawn_pos = Vector3(randf_range(-area_extent_x,area_extent_x),1.7,randf_range(-area_extent_z,area_extent_z))
			pos_query.position = spawn_pos
		# add a spawn position within Area3D
		spawn_positions.insert(n,spawn_pos)
		
		### SETTING TYPES ###
		spawn_types.insert(n,available_to_spawn[randi_range(0,available_to_spawn.size()-1)])

func _on_timer_timeout():
	for n in amount_to_spawn:
		var pos = spawn_positions[n]
		var monster = spawn_types[n].instantiate()
		monster.position = pos
		get_tree().get_root().add_child(monster)
