if(global.playerDead) {
	image_speed = 0;
	return;
}
image_speed = 1;

var passo = delta_time / 1000000;
y += vy * passo;
vy += GRAVITA * passo;

if(y > room_height + 48)
	instance_destroy();
