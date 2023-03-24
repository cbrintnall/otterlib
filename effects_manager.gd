extends Node

# prevents tweens from tripping out
var _trackers = {}

func bounce(target: Node3D):
	if target in _trackers and _trackers[target].is_running():
		return

	var tween = get_tree().create_tween()
	_trackers[target] = tween
	var sprite = target
	var time = 0.1
	var scalar = 1.25
	
	tween.tween_property(
		sprite,
		"scale",
		Vector3(sprite.scale.x*scalar, sprite.scale.y/scalar, sprite.scale.z),
		time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	tween.tween_property(
		sprite,
		"scale",
		Vector3(sprite.scale.x, sprite.scale.y, sprite.scale.z),
		time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)

func error_bounce(target: Sprite3D):
	if target in _trackers and _trackers[target].is_running():
		return

	var tween = get_tree().create_tween()
	_trackers[target] = tween
	var sprite = target
	var time = 0.1
	var scalar = 1.25
	
	tween.tween_property(
		sprite,
		"scale",
		Vector3(sprite.scale.x*scalar, sprite.scale.y/scalar, sprite.scale.z),
		time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	tween.parallel().tween_property(
		sprite,
		"modulate",
		Color.DARK_RED,
		time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	tween.tween_property(
		sprite,
		"scale",
		Vector3(sprite.scale.x, sprite.scale.y, sprite.scale.z),
		time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	tween.parallel().tween_property(
		sprite,
		"modulate",
		Color.WHITE,
		time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
