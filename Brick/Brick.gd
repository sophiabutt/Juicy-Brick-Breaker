extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var tween

var powerup_prob = 0.1

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	position.x = new_position.x
	position.y = 100
	tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
	if score >= 100:
		$ColorRect.color = Color8(255,135,135,255)
	elif score >= 90:
		$ColorRect.color = Color8(250,162,193,255)
	elif score >= 80:
		$ColorRect.color = Color8(255,216,168,255)
	elif score >= 70:
		$ColorRect.color = Color8(255,236,153,255)
	elif score >= 60:
		$ColorRect.color = Color8(178,242,187,255)
	elif score >= 50:
		$ColorRect.color = Color8(165,216,255,255)
	elif score >= 40:
		$ColorRect.color = Color8(186,200,255,255)
	else:
		$ColorRect.color = Color8(238,190,250,255)

func _physics_process(_delta):
	if dying:
		queue_free()

func hit(_ball):
	die()

func die():
	dying = true
	collision_layer = 0
	$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instantiate()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
