if(global.playerDead) return;

var passo = delta_time / 1000000;

vy += GRAVITA * passo;
y += vy * passo;

// Nothing stops it: it goes through the blocks and out of the bottom.
if(y > room_height + 16) {
	instance_destroy();
	return;
}

if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
