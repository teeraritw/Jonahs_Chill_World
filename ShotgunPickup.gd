extends Area3D

const AMMO_INCREASE = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	if body.name == "Player":
		body.ammo_list["Shotgun"] = body.ammo_list["Shotgun"] + AMMO_INCREASE
		self.queue_free()
