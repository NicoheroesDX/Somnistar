extends Sprite2D

var speed = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	speed = Global.speed;
	position.x -= speed * delta
