extends Area3D

const AMMO_INCREASE = 10

func _on_body_entered(body):
	if body.name == "Player":
		body.ammo_list["Pistol"] = body.ammo_list["Pistol"] + AMMO_INCREASE
		self.queue_free()
