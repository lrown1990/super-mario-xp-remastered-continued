if(global.playerDead) {
	image_speed = 0;
	return;
}
image_speed = 1;

var passo = delta_time / 1000000;

x += vx * passo;
y += vy * passo;
vy += GRAVITA * passo;

// nothing stops it, not even the floor: it drops out of the screen
if(x < -32 || x > room_width + 32 || y > room_height + 32) {
	instance_destroy();
	return;
}

// qualifier 16, ev. 22: two points
if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
