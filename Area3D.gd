extends Area3D

const AMMO_INCREASE = 10

func _on_body_entered(body):
	if body.name == "Player":
		body.ammo_list["Pistol"] = body.ammo_list["Pistol"] + AMMO_INCREASE
		var pickup_audio = body.get_node("AmmoPickup")
		pickup_audio.pitch_scale = 1
		pickup_audio.play()
		self.queue_free()
