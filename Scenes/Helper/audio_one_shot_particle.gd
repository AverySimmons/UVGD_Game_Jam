extends GPUParticles2D

func _ready():
	emitting = true
	$Sound.play()
	await $Sound.finished
	queue_free()
