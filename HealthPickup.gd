extends Area3D

const HEAL_AMOUNT = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	if body.name == "Player" and body.hp < body.MAX_HP:
		if body.hp+HEAL_AMOUNT>body.MAX_HP:
			body.hp = body.MAX_HP
		else:
			body.hp += HEAL_AMOUNT
		print_debug(body.hp)
		self.queue_free()
