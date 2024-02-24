extends CanvasGroup

const FADE_IN_TIME : float = 0.5
const FADE_OUT_TIME : float = 0.5
const WAIT_TIME : float = 0.4
const MAX_SCALE = Vector2(1600, 1600)

@onready var mask = $MeshInstance2D

func levelStart(pos : Vector2) -> void:
	get_tree().paused = true
	mask.global_position = pos
	mask.scale *= 0
	var t = create_tween()
	t.tween_property(mask, "scale", MAX_SCALE, FADE_IN_TIME).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	await t.finished
	get_tree().paused = false

func levelEnd(pos : Vector2) -> void:
	get_tree().paused = true
	mask.global_position = pos
	mask.scale = MAX_SCALE
	var t = create_tween()
	t.tween_property(mask, "scale", Vector2.ZERO, FADE_OUT_TIME).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	await t.finished
	await get_tree().create_timer(WAIT_TIME).timeout
	get_tree().paused = false
