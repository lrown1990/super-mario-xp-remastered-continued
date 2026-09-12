if(global.playerDead) {
	image_speed = 0;
	return;
}
image_speed = 1;

var passo = delta_time / 1000000;

x += vx * passo;
var d = bersaglioY - y;
if(d != 0) {
	var m = VELOCITA_VERTICALE * passo;
	if(abs(d) <= m) y = bersaglioY;
	else y += sign(d) * m;
}

// out of the room and it is gone
if(x < -32 || x > room_width + 32 || y < -48 || y > room_height + 48) {
	instance_destroy();
	return;
}

// qualifier 16, ev. 22: two points
if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
